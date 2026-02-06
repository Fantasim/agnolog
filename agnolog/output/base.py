"""
Base output handler interface.

All output handlers implement this interface, allowing them to be
used interchangeably throughout the application.
"""

from abc import ABC, abstractmethod


class BaseOutputHandler(ABC):
    """
    Abstract base class for output handlers.

    Output handlers are responsible for writing formatted log
    content to various destinations (files, streams, etc.).

    Subclasses must implement:
    - write(): Write a single string
    - close(): Clean up resources
    """

    @abstractmethod
    def write(self, content: str) -> None:
        """
        Write content to the output.

        Args:
            content: The formatted content to write
        """
        pass

    @abstractmethod
    def close(self) -> None:
        """
        Close the output handler and release resources.

        This should be called when done writing to ensure
        all data is flushed and resources are released.
        """
        pass

    def write_batch(self, contents: list[str]) -> None:
        """
        Write multiple content strings.

        Default implementation calls write() for each item.
        Subclasses may override for efficiency.

        Args:
            contents: List of formatted content strings
        """
        for content in contents:
            self.write(content)

    def __enter__(self) -> "BaseOutputHandler":
        """Support context manager protocol."""
        return self

    def __exit__(
        self,
        exc_type: object,
        exc_val: object,
        exc_tb: object,
    ) -> None:
        """Ensure close is called on context exit."""
        self.close()

    def __repr__(self) -> str:
        return f"{self.__class__.__name__}()"
