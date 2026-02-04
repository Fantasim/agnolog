"""
Log formatters for converting LogEntry objects to output strings.

Provides multiple output formats using the Strategy pattern:
- JSONFormatter: Machine-readable JSON output
- TextFormatter: Human-readable printf-style output

Usage:
    from agnolog.formatters import JSONFormatter, TextFormatter

    json_fmt = JSONFormatter(pretty=True)
    text_fmt = TextFormatter()

    print(json_fmt.format(entry))
    print(text_fmt.format(entry))
"""

from agnolog.formatters.base import BaseFormatter
from agnolog.formatters.json_formatter import JSONFormatter
from agnolog.formatters.text_formatter import TextFormatter

__all__ = [
    "BaseFormatter",
    "JSONFormatter",
    "TextFormatter",
]
