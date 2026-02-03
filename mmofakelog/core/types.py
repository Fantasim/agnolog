"""
Type definitions for the Fake Log Generator.

This module contains enums, dataclasses, and type aliases
used throughout the application.
"""

from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum, auto
from typing import Any, Callable, Dict, List, Optional, Protocol, Type


# =============================================================================
# ENUMS
# =============================================================================


class LogSeverity(Enum):
    """
    Severity levels for log entries.

    Follows standard logging conventions with numeric values
    for easy comparison (higher = more severe).
    """

    DEBUG = 0
    INFO = 1
    WARNING = 2
    ERROR = 3
    CRITICAL = 4


class LogFormat(Enum):
    """Output format types for log entries."""

    JSON = auto()
    TEXT = auto()


class RecurrencePattern(Enum):
    """
    How often a log type typically occurs.

    These patterns control the frequency of log generation.
    """

    VERY_FREQUENT = auto()  # ~1 per second
    FREQUENT = auto()       # ~5 per minute
    NORMAL = auto()         # ~0.5 per minute
    INFREQUENT = auto()     # ~2 per hour
    RARE = auto()           # ~1 per day


# =============================================================================
# DATACLASSES
# =============================================================================


@dataclass(frozen=True)
class LogTypeMetadata:
    """
    Metadata describing a registered log type.

    Attributes:
        name: Unique identifier (e.g., "player.login", "finance.transaction")
        category: Category string (e.g., "player", "server", "finance")
        severity: Default severity level
        recurrence: How often this log type typically fires
        description: Human-readable description
        text_template: Printf-style template for text output
        tags: Optional tags for filtering/organization
    """

    name: str
    category: str  # Flexible string category
    severity: LogSeverity
    recurrence: RecurrencePattern
    description: str
    text_template: str
    tags: tuple = field(default_factory=tuple)

    def __post_init__(self) -> None:
        """Validate metadata after initialization."""
        if not self.name:
            raise ValueError("Log type name cannot be empty")
        if "." not in self.name:
            raise ValueError(
                f"Log type name must be namespaced (e.g., 'player.login'), got: {self.name}"
            )


@dataclass
class LogEntry:
    """
    A generated log entry.

    Represents a single log event with all associated data.
    """

    log_type: str
    timestamp: datetime
    severity: LogSeverity
    category: str  # Flexible string category
    data: Dict[str, Any]
    server_id: Optional[str] = None
    session_id: Optional[str] = None

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for serialization."""
        result: Dict[str, Any] = {
            "log_type": self.log_type,
            "timestamp": self.timestamp.isoformat(),
            "severity": self.severity.name,
            "category": self.category,
            **self.data,
        }
        if self.server_id:
            result["server_id"] = self.server_id
        if self.session_id:
            result["session_id"] = self.session_id
        return result


# =============================================================================
# PROTOCOLS (for dependency injection)
# =============================================================================


class FormatterProtocol(Protocol):
    """Protocol defining the log formatter interface."""

    def format(self, entry: LogEntry) -> str:
        """Format a single log entry."""
        ...

    def format_batch(self, entries: List[LogEntry]) -> str:
        """Format multiple log entries."""
        ...


class OutputHandlerProtocol(Protocol):
    """Protocol defining the output handler interface."""

    def write(self, content: str) -> None:
        """Write content to the output."""
        ...

    def close(self) -> None:
        """Close the output handler."""
        ...


# =============================================================================
# TYPE ALIASES
# =============================================================================

# Generator callable type
GeneratorCallable = Callable[..., Dict[str, Any]]

# Log type registry entry
RegistryEntry = tuple[LogTypeMetadata, Type["BaseLogGenerator"]]  # type: ignore

# Time range tuple
TimeRange = tuple[datetime, datetime]

# Callback for log entry events
LogEntryCallback = Callable[[LogEntry], None]


# =============================================================================
# BACKWARDS COMPATIBILITY
# =============================================================================

# LogCategory is now just a string, but we provide common values as constants
# for backwards compatibility and convenience

class _LogCategoryMeta(type):
    """Metaclass to make LogCategory iterable."""

    def __iter__(cls):
        return iter(cls._ALL)

    def __len__(cls):
        return len(cls._ALL)


class LogCategory(metaclass=_LogCategoryMeta):
    """
    Common log category constants.

    Categories are now flexible strings. These constants are provided
    for convenience but you can use any string as a category.
    """
    PLAYER = "PLAYER"
    SERVER = "SERVER"
    SECURITY = "SECURITY"
    ECONOMY = "ECONOMY"
    COMBAT = "COMBAT"
    TECHNICAL = "TECHNICAL"

    # For iteration compatibility
    _ALL = [PLAYER, SERVER, SECURITY, ECONOMY, COMBAT, TECHNICAL]

    @classmethod
    def __len__(cls):
        return len(cls._ALL)
