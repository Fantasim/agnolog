"""
CSV formatter for log entries in loghub format.

Produces output compatible with the loghub benchmark format:
- Structured CSV with LineId, Date, Day, Time, Component, Pid, Content, EventId, EventTemplate
- Templates CSV with EventId, EventTemplate

Reference: https://github.com/logpai/loghub
"""

import csv
import io
import re

from agnolog.core.constants import LOGHUB_CSV_COLUMNS, LOGHUB_PLACEHOLDER, LOGHUB_TEMPLATE_COLUMNS
from agnolog.core.registry import LogTypeRegistry, get_registry
from agnolog.core.types import LogEntry
from agnolog.formatters.base import BaseFormatter
from agnolog.formatters.text_formatter import TextFormatter
from agnolog.logutils import get_internal_logger


def template_to_loghub(text_template: str) -> str:
    """
    Convert a printf-style template to loghub format.

    Replaces {variable} placeholders with <*> placeholders.

    Args:
        text_template: Template with {var} placeholders

    Returns:
        Template with <*> placeholders

    Example:
        >>> template_to_loghub("[{timestamp}] LOGIN: {username} from {ip}")
        "[<*>] LOGIN: <*> from <*>"
    """
    return re.sub(r"\{[^}]+\}", LOGHUB_PLACEHOLDER, text_template)


class LoghubCSVFormatter(BaseFormatter):
    """
    Formats log entries as CSV in loghub benchmark format.

    Produces structured CSV output compatible with log parsing research tools.
    Each log entry is mapped to its template using EventId.

    Usage:
        formatter = LoghubCSVFormatter()
        header = formatter.format_header()
        for entry in entries:
            row = formatter.format(entry)

        templates = formatter.get_templates()
    """

    def __init__(
        self,
        registry: LogTypeRegistry | None = None,
        component: str = "Server",
        default_pid: int = 1000,
    ) -> None:
        """
        Initialize loghub CSV formatter.

        Args:
            registry: Log type registry (uses singleton if None)
            component: Component/hostname field value
            default_pid: Default process ID when not in log data
        """
        self._registry = registry or get_registry()
        self._component = component
        self._default_pid = default_pid
        self._logger = get_internal_logger()

        # Text formatter for generating Content column
        self._text_formatter = TextFormatter(registry=self._registry)

        # Template mapping: log_type -> (EventId, EventTemplate, MergeGroups)
        self._template_map: dict[str, tuple[str, str, str]] = {}
        self._line_id = 0

        self._build_template_map()

    def _build_template_map(self) -> None:
        """Build mapping from log types to EventIds, templates, and merge groups."""
        all_metadata = self._registry.all_metadata()

        for idx, (name, metadata) in enumerate(sorted(all_metadata.items()), start=1):
            event_id = f"E{idx}"
            event_template = template_to_loghub(metadata.text_template)
            merge_groups = ",".join(metadata.merge_groups) if metadata.merge_groups else ""
            self._template_map[name] = (event_id, event_template, merge_groups)

        self._logger.debug(f"Built template map with {len(self._template_map)} entries")

    def reset_line_counter(self) -> None:
        """Reset the line ID counter to 0."""
        self._line_id = 0

    def format_header(self) -> str:
        """
        Return the CSV header row.

        Returns:
            CSV header string with column names
        """
        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow(LOGHUB_CSV_COLUMNS)
        return output.getvalue().rstrip("\r\n")

    def format(self, entry: LogEntry) -> str:
        """
        Format a single log entry as a CSV row.

        Automatically increments the line ID counter.

        Args:
            entry: Log entry to format

        Returns:
            CSV row string
        """
        self._line_id += 1

        # Get template info
        template_info = self._template_map.get(entry.log_type)
        if template_info:
            event_id, event_template, _ = template_info  # Ignore merge_groups for row output
        else:
            # Fallback for unknown log types
            event_id = "E0"
            event_template = LOGHUB_PLACEHOLDER
            self._logger.warning(f"No template found for log type: {entry.log_type}")

        # Generate Content using text formatter
        content = self._text_formatter.format(entry)

        # Extract PID from data if available
        pid = entry.data.get("pid", entry.data.get("process_id", self._default_pid))

        # Build row
        row = [
            self._line_id,
            entry.timestamp.strftime("%b"),  # Month abbreviation
            entry.timestamp.day,
            entry.timestamp.strftime("%H:%M:%S"),
            self._component,
            pid,
            content,
            event_id,
            event_template,
        ]

        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow(row)
        return output.getvalue().rstrip("\r\n")

    def format_batch(self, entries: list[LogEntry]) -> str:
        """
        Format multiple entries as CSV rows (no header).

        Args:
            entries: List of log entries

        Returns:
            Multi-line CSV string
        """
        return "\n".join(self.format(entry) for entry in entries)

    def format_batch_with_header(self, entries: list[LogEntry]) -> str:
        """
        Format multiple entries as complete CSV with header.

        Args:
            entries: List of log entries

        Returns:
            Complete CSV string with header and data rows
        """
        lines = [self.format_header()]
        lines.extend(self.format(entry) for entry in entries)
        return "\n".join(lines)

    def get_templates(self) -> list[tuple[str, str, str]]:
        """
        Get all templates for the templates.csv file.

        Returns:
            List of (EventId, EventTemplate, MergeGroups) tuples, sorted by EventId
        """
        return sorted(self._template_map.values(), key=lambda x: int(x[0][1:]))

    def format_templates_csv(self) -> str:
        """
        Format the templates CSV content.

        Returns:
            Complete templates CSV with header and data
        """
        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow(LOGHUB_TEMPLATE_COLUMNS)

        for event_id, event_template, merge_groups in self.get_templates():
            writer.writerow([event_id, event_template, merge_groups])

        return output.getvalue().rstrip("\r\n")

    def __repr__(self) -> str:
        return f"LoghubCSVFormatter(component={self._component!r}, templates={len(self._template_map)})"
