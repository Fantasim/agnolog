"""
Base log generator class.

All log generators inherit from BaseLogGenerator and implement
the _generate_data method to produce log-specific data.
"""

from abc import ABC, abstractmethod
from datetime import datetime
from typing import Any, Dict, Optional, TYPE_CHECKING

from mmofakelog.core.types import LogEntry, LogTypeMetadata
from mmofakelog.logging import InternalLoggerMixin

if TYPE_CHECKING:
    from mmofakelog.ai.client import AIClient


class BaseLogGenerator(ABC, InternalLoggerMixin):
    """
    Abstract base class for all log generators.

    Subclasses implement the _generate_data method to produce
    log-specific data dictionaries. The base class handles
    common functionality like timestamp handling and entry creation.

    Usage:
        @register_log_type(name="player.login", ...)
        class PlayerLoginGenerator(BaseLogGenerator):
            def _generate_data(self, **kwargs):
                return {
                    "username": generate_player_name(),
                    "ip": generate_ip_address(),
                    ...
                }
    """

    # Metadata is set by the @register_log_type decorator
    _log_type_metadata: Optional[LogTypeMetadata] = None

    def __init__(
        self,
        ai_client: Optional["AIClient"] = None,
    ) -> None:
        """
        Initialize generator with optional dependencies.

        Args:
            ai_client: Optional AI client for dynamic content
        """
        self._ai_client = ai_client

    def generate(
        self,
        timestamp: datetime,
        metadata: LogTypeMetadata,
        server_id: Optional[str] = None,
        session_id: Optional[str] = None,
        **kwargs: Any,
    ) -> LogEntry:
        """
        Generate a log entry.

        Args:
            timestamp: Log timestamp
            metadata: Log type metadata
            server_id: Optional server identifier
            session_id: Optional session identifier
            **kwargs: Additional generation parameters

        Returns:
            Complete LogEntry
        """
        try:
            data = self._generate_data(**kwargs)
        except Exception as e:
            self._log_error(f"Error generating data for {metadata.name}: {e}")
            # Return minimal data on error
            data = {"error": str(e)}

        return LogEntry(
            log_type=metadata.name,
            timestamp=timestamp,
            severity=metadata.severity,
            category=metadata.category,
            data=data,
            server_id=server_id,
            session_id=session_id,
        )

    @abstractmethod
    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        """
        Generate the data dictionary for this log type.

        Must be implemented by subclasses to provide log-specific data.

        Args:
            **kwargs: Optional parameters to customize generation

        Returns:
            Dictionary of log data fields
        """
        pass

    def __repr__(self) -> str:
        if self._log_type_metadata:
            return f"{self.__class__.__name__}(type={self._log_type_metadata.name})"
        return f"{self.__class__.__name__}()"
