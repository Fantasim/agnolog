"""
JSON formatter for log entries.

Produces machine-readable JSON output suitable for log
aggregation systems, analysis tools, and APIs.
"""

import json
from datetime import datetime
from typing import Any

from agnolog.core.types import LogEntry
from agnolog.formatters.base import BaseFormatter


class JSONFormatter(BaseFormatter):
    """
    Formats log entries as JSON.

    Features:
    - Pretty printing option for human readability
    - Configurable metadata inclusion
    - Proper datetime serialization
    - Handles nested objects and special types

    Usage:
        formatter = JSONFormatter(pretty=True)
        json_str = formatter.format(entry)
    """

    def __init__(
        self,
        pretty: bool = False,
        include_metadata: bool = True,
        sort_keys: bool = False,
        ensure_ascii: bool = False,
        date_format: str | None = None,
    ) -> None:
        """
        Initialize JSON formatter.

        Args:
            pretty: Whether to indent output for readability
            include_metadata: Whether to include server_id, session_id
            sort_keys: Whether to sort keys alphabetically
            ensure_ascii: Whether to escape non-ASCII characters
            date_format: Custom strftime format for dates (uses ISO if None)
        """
        self._pretty = pretty
        self._include_metadata = include_metadata
        self._sort_keys = sort_keys
        self._ensure_ascii = ensure_ascii
        self._date_format = date_format
        self._indent = 2 if pretty else None

    def _serialize_value(self, value: Any) -> Any:
        """
        Serialize a value to JSON-compatible type.

        Handles special types like datetime, enums, etc.
        """
        if isinstance(value, datetime):
            if self._date_format:
                return value.strftime(self._date_format)
            return value.isoformat()
        if hasattr(value, "name"):  # Enum
            return value.name
        if hasattr(value, "to_dict"):  # Custom objects
            return value.to_dict()
        if isinstance(value, (list, tuple)):
            return [self._serialize_value(v) for v in value]
        if isinstance(value, dict):
            return {k: self._serialize_value(v) for k, v in value.items()}
        return value

    def _entry_to_dict(self, entry: LogEntry) -> dict:
        """Convert log entry to dictionary for JSON serialization."""
        result = {
            "timestamp": self._serialize_value(entry.timestamp),
            "type": entry.log_type,
            "severity": entry.severity.name,
            "category": entry.category,  # Category is now a string
        }

        # Add all data fields
        for key, value in entry.data.items():
            result[key] = self._serialize_value(value)

        # Add optional metadata
        if self._include_metadata:
            if entry.server_id:
                result["server_id"] = entry.server_id
            if entry.session_id:
                result["session_id"] = entry.session_id

        return result

    def format(self, entry: LogEntry) -> str:
        """
        Format a single entry as JSON.

        Args:
            entry: Log entry to format

        Returns:
            JSON string representation
        """
        data = self._entry_to_dict(entry)
        return json.dumps(
            data,
            indent=self._indent,
            sort_keys=self._sort_keys,
            ensure_ascii=self._ensure_ascii,
            default=str,  # Fallback for any unhandled types
        )

    def format_batch(self, entries: list[LogEntry]) -> str:
        """
        Format multiple entries as a JSON array.

        Args:
            entries: List of log entries to format

        Returns:
            JSON array string
        """
        data = [self._entry_to_dict(entry) for entry in entries]
        return json.dumps(
            data,
            indent=self._indent,
            sort_keys=self._sort_keys,
            ensure_ascii=self._ensure_ascii,
            default=str,
        )

    def format_ndjson(self, entries: list[LogEntry]) -> str:
        """
        Format entries as newline-delimited JSON (NDJSON).

        This format is preferred by many log aggregation systems
        as it allows line-by-line processing.

        Args:
            entries: List of log entries to format

        Returns:
            NDJSON string (one JSON object per line)
        """
        lines = []
        for entry in entries:
            data = self._entry_to_dict(entry)
            # NDJSON should not be pretty-printed
            lines.append(
                json.dumps(
                    data,
                    sort_keys=self._sort_keys,
                    ensure_ascii=self._ensure_ascii,
                    default=str,
                )
            )
        return "\n".join(lines)

    def __repr__(self) -> str:
        return f"JSONFormatter(pretty={self._pretty}, include_metadata={self._include_metadata})"
