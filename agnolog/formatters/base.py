"""
Base formatter interface using the Strategy pattern.

All formatters implement this interface, allowing them to be
used interchangeably throughout the application.
"""

from abc import ABC, abstractmethod
from typing import List

from agnolog.core.types import LogEntry


class BaseFormatter(ABC):
    """
    Abstract base class for log formatters.

    Uses the Strategy pattern to allow different formatting
    strategies to be plugged in at runtime.

    Subclasses must implement:
    - format(): Format a single log entry
    - format_batch(): Format multiple log entries
    """

    @abstractmethod
    def format(self, entry: LogEntry) -> str:
        """
        Format a single log entry to string.

        Args:
            entry: The log entry to format

        Returns:
            Formatted string representation
        """
        pass

    @abstractmethod
    def format_batch(self, entries: List[LogEntry]) -> str:
        """
        Format multiple log entries to string.

        Args:
            entries: List of log entries to format

        Returns:
            Formatted string containing all entries
        """
        pass

    def __repr__(self) -> str:
        return f"{self.__class__.__name__}()"
