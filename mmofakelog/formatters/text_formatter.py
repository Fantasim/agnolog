"""
Text formatter for log entries.

Produces human-readable printf-style output suitable for
console display and traditional log files.
"""

from typing import Dict, List, Optional, Any

from mmofakelog.core.constants import SHORT_TIMESTAMP_FORMAT
from mmofakelog.core.registry import LogTypeRegistry, get_registry
from mmofakelog.core.types import LogEntry
from mmofakelog.formatters.base import BaseFormatter
from mmofakelog.logging import get_internal_logger


class TextFormatter(BaseFormatter):
    """
    Formats log entries as printf-style text.

    Uses text templates registered with each log type to produce
    human-readable output. Falls back to a default format if
    no template is available.

    Usage:
        formatter = TextFormatter()
        text = formatter.format(entry)
        # Output: "[2024-01-15 12:30:45] LOGIN: DragonSlayer from 192.168.1.100"
    """

    # Default template when log type template is not available
    DEFAULT_TEMPLATE = "[{timestamp}] [{severity}] [{category}] {log_type}: {data}"

    def __init__(
        self,
        registry: Optional[LogTypeRegistry] = None,
        timestamp_format: Optional[str] = None,
        include_severity: bool = False,
        include_category: bool = False,
        color_enabled: bool = False,
    ) -> None:
        """
        Initialize text formatter.

        Args:
            registry: Log type registry (uses singleton if None)
            timestamp_format: strftime format for timestamps
            include_severity: Whether to include severity in default format
            include_category: Whether to include category in default format
            color_enabled: Whether to use ANSI colors (for terminal output)
        """
        self._registry = registry or get_registry()
        self._timestamp_format = timestamp_format or SHORT_TIMESTAMP_FORMAT
        self._include_severity = include_severity
        self._include_category = include_category
        self._color_enabled = color_enabled
        self._logger = get_internal_logger()

    # ANSI color codes for severity levels
    SEVERITY_COLORS: Dict[str, str] = {
        "DEBUG": "\033[36m",  # Cyan
        "INFO": "\033[32m",  # Green
        "WARNING": "\033[33m",  # Yellow
        "ERROR": "\033[31m",  # Red
        "CRITICAL": "\033[35m",  # Magenta
    }
    RESET_COLOR = "\033[0m"

    def _colorize(self, text: str, severity: str) -> str:
        """Apply ANSI color based on severity."""
        if not self._color_enabled:
            return text
        color = self.SEVERITY_COLORS.get(severity, "")
        if color:
            return f"{color}{text}{self.RESET_COLOR}"
        return text

    def _format_data_value(self, value: Any) -> str:
        """Format a data value for text output."""
        if isinstance(value, bool):
            return "yes" if value else "no"
        if isinstance(value, float):
            return f"{value:.2f}"
        if isinstance(value, (list, tuple)):
            return ", ".join(str(v) for v in value)
        if isinstance(value, dict):
            return str(value)
        return str(value)

    def _build_format_dict(self, entry: LogEntry) -> Dict[str, str]:
        """Build the format dictionary for template substitution."""
        format_dict: Dict[str, str] = {
            "timestamp": entry.timestamp.strftime(self._timestamp_format),
            "severity": entry.severity.name,
            "category": entry.category.name,
            "log_type": entry.log_type,
        }

        # Add all data fields
        for key, value in entry.data.items():
            format_dict[key] = self._format_data_value(value)

        # Add optional metadata
        if entry.server_id:
            format_dict["server_id"] = entry.server_id
        if entry.session_id:
            format_dict["session_id"] = entry.session_id

        return format_dict

    def _format_with_template(
        self, entry: LogEntry, template: str, format_dict: Dict[str, str]
    ) -> str:
        """Format entry using template, handling missing keys gracefully."""
        try:
            return template.format(**format_dict)
        except KeyError as e:
            # Log warning and fall back to default format
            missing_key = str(e).strip("'")
            self._logger.warning(
                f"Template key '{missing_key}' not found for {entry.log_type}, "
                f"available keys: {list(format_dict.keys())}"
            )
            return self._format_default(entry, format_dict)

    def _format_default(self, entry: LogEntry, format_dict: Dict[str, str]) -> str:
        """Format entry using default format."""
        parts = [f"[{format_dict['timestamp']}]"]

        if self._include_severity:
            parts.append(f"[{format_dict['severity']}]")

        if self._include_category:
            parts.append(f"[{format_dict['category']}]")

        parts.append(f"{entry.log_type}:")

        # Add data fields
        data_parts = []
        for key, value in entry.data.items():
            data_parts.append(f"{key}={format_dict.get(key, str(value))}")

        parts.append(" ".join(data_parts))

        return " ".join(parts)

    def format(self, entry: LogEntry) -> str:
        """
        Format a single entry as text.

        Uses the text_template from the log type's metadata if available,
        otherwise falls back to the default format.

        Args:
            entry: Log entry to format

        Returns:
            Formatted text string
        """
        format_dict = self._build_format_dict(entry)

        # Try to get template from registry
        metadata = self._registry.get_metadata(entry.log_type)

        if metadata and metadata.text_template:
            result = self._format_with_template(
                entry, metadata.text_template, format_dict
            )
        else:
            result = self._format_default(entry, format_dict)

        # Apply color if enabled
        return self._colorize(result, entry.severity.name)

    def format_batch(self, entries: List[LogEntry]) -> str:
        """
        Format multiple entries as newline-separated text.

        Args:
            entries: List of log entries to format

        Returns:
            Multi-line text string
        """
        return "\n".join(self.format(entry) for entry in entries)

    def __repr__(self) -> str:
        return (
            f"TextFormatter(timestamp_format={self._timestamp_format!r}, "
            f"color_enabled={self._color_enabled})"
        )


class ColorTextFormatter(TextFormatter):
    """
    Text formatter with ANSI colors enabled by default.

    Convenience class for terminal output.
    """

    def __init__(self, **kwargs: Any) -> None:
        kwargs["color_enabled"] = True
        super().__init__(**kwargs)
