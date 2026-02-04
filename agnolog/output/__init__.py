"""
Output handlers for writing formatted log entries.

Provides multiple output destinations:
- StreamOutputHandler: Write to stdout/stderr
- FileOutputHandler: Write to files
- RotatingFileHandler: Write to files with rotation

Usage:
    from agnolog.output import StreamOutputHandler, FileOutputHandler

    handler = FileOutputHandler("logs/server.log")
    handler.write(formatted_entry)
    handler.close()
"""

from agnolog.output.base import BaseOutputHandler
from agnolog.output.file_handler import FileOutputHandler, RotatingFileHandler
from agnolog.output.stream_handler import StreamOutputHandler

__all__ = [
    "BaseOutputHandler",
    "StreamOutputHandler",
    "FileOutputHandler",
    "RotatingFileHandler",
]
