"""
Stream output handler for writing to stdout/stderr.

Useful for console output and piping to other tools.
"""

import sys
from typing import TextIO

from agnolog.output.base import BaseOutputHandler


class StreamOutputHandler(BaseOutputHandler):
    """
    Output handler that writes to a stream (stdout/stderr).

    Features:
    - Configurable stream (stdout by default)
    - Optional line ending control
    - Flush control for real-time output

    Usage:
        handler = StreamOutputHandler()  # stdout
        handler = StreamOutputHandler(sys.stderr)  # stderr
        handler.write("log entry")
    """

    def __init__(
        self,
        stream: TextIO | None = None,
        add_newline: bool = True,
        auto_flush: bool = True,
    ) -> None:
        """
        Initialize stream output handler.

        Args:
            stream: Output stream (defaults to stdout)
            add_newline: Whether to add newline after each write
            auto_flush: Whether to flush after each write
        """
        self._stream = stream or sys.stdout
        self._add_newline = add_newline
        self._auto_flush = auto_flush
        self._closed = False

    def write(self, content: str) -> None:
        """
        Write content to the stream.

        Args:
            content: The formatted content to write
        """
        if self._closed:
            return

        if self._add_newline and not content.endswith("\n"):
            content = content + "\n"

        self._stream.write(content)

        if self._auto_flush:
            self._stream.flush()

    def close(self) -> None:
        """
        Close the handler.

        Note: Does not close the underlying stream (stdout/stderr
        should not be closed).
        """
        if not self._closed:
            self._stream.flush()
            self._closed = True

    def flush(self) -> None:
        """Flush the stream."""
        if not self._closed:
            self._stream.flush()

    def __repr__(self) -> str:
        stream_name = getattr(self._stream, "name", str(self._stream))
        return f"StreamOutputHandler(stream={stream_name})"


class NullOutputHandler(BaseOutputHandler):
    """
    Output handler that discards all output.

    Useful for testing or when output is not needed.
    """

    def write(self, content: str) -> None:
        """Discard content."""
        pass

    def close(self) -> None:
        """Nothing to close."""
        pass

    def __repr__(self) -> str:
        return "NullOutputHandler()"
