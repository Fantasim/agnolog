"""
Type definitions for the MMORPG Fake Log Generator.

This module contains all enums, dataclasses, and type aliases
used throughout the application. These provide type safety
and clear interfaces between components.
"""

from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum, auto
from typing import Any, Callable, Dict, List, Optional, Protocol, Type


# =============================================================================
# ENUMS
# =============================================================================


class LogCategory(Enum):
    """
    Main categories for log types.

    Each log type belongs to exactly one category, which helps
    organize logs and allows filtering by category.
    """

    PLAYER = auto()  # Player actions: login, combat, inventory, chat, etc.
    SERVER = auto()  # Server events: start/stop, performance, world events
    SECURITY = auto()  # Security/admin: bans, suspicious activity, admin commands
    ECONOMY = auto()  # Economy: transactions, auction, vendors, trades
    COMBAT = auto()  # Combat/PvE/PvP: damage, dungeons, raids, PvP
    TECHNICAL = auto()  # Technical: connections, packets, errors, latency


class LogSeverity(Enum):
    """
    Severity levels for log entries.

    Follows standard logging conventions with numeric values
    for easy comparison (higher = more severe).
    """

    DEBUG = 0  # Detailed debugging information
    INFO = 1  # Normal operational messages
    WARNING = 2  # Potentially problematic situations
    ERROR = 3  # Error conditions that don't halt operation
    CRITICAL = 4  # Critical errors that may require intervention


class LogFormat(Enum):
    """
    Output format types for log entries.

    Determines how log entries are serialized for output.
    """

    JSON = auto()  # JSON format (machine-readable)
    TEXT = auto()  # Printf-style text format (human-readable)


class RecurrencePattern(Enum):
    """
    How often a log type typically occurs.

    These patterns control the frequency of log generation
    during simulation. The actual timing uses exponential
    distribution for realistic randomness.
    """

    VERY_FREQUENT = auto()  # ~1 per second (packets, damage, cache ops)
    FREQUENT = auto()  # ~5 per minute (combat actions, movement, chat)
    NORMAL = auto()  # ~0.5 per minute (trades, quests, logins)
    INFREQUENT = auto()  # ~2 per hour (achievements, boss kills)
    RARE = auto()  # ~1 per day (server restart, bans)


class ItemRarity(Enum):
    """Item rarity levels with associated drop weights."""

    POOR = auto()
    COMMON = auto()
    UNCOMMON = auto()
    RARE = auto()
    EPIC = auto()
    LEGENDARY = auto()
    ARTIFACT = auto()


class Faction(Enum):
    """Player factions."""

    ALLIANCE = auto()
    HORDE = auto()
    NEUTRAL = auto()


class DamageType(Enum):
    """Types of damage in combat."""

    PHYSICAL = auto()
    FIRE = auto()
    FROST = auto()
    ARCANE = auto()
    NATURE = auto()
    SHADOW = auto()
    HOLY = auto()


class CombatResult(Enum):
    """Possible results of a combat action."""

    HIT = auto()
    CRITICAL = auto()
    MISS = auto()
    DODGE = auto()
    PARRY = auto()
    BLOCK = auto()
    RESIST = auto()
    ABSORB = auto()


class ConnectionState(Enum):
    """Network connection states."""

    CONNECTING = auto()
    CONNECTED = auto()
    AUTHENTICATING = auto()
    AUTHENTICATED = auto()
    DISCONNECTING = auto()
    DISCONNECTED = auto()


class QuestState(Enum):
    """Quest progress states."""

    AVAILABLE = auto()
    IN_PROGRESS = auto()
    COMPLETED = auto()
    TURNED_IN = auto()
    FAILED = auto()
    ABANDONED = auto()


class TradeState(Enum):
    """Player trade states."""

    INITIATED = auto()
    PENDING = auto()
    ACCEPTED = auto()
    CANCELLED = auto()
    COMPLETED = auto()


class AuctionState(Enum):
    """Auction listing states."""

    LISTED = auto()
    BID = auto()
    SOLD = auto()
    EXPIRED = auto()
    CANCELLED = auto()


# =============================================================================
# DATACLASSES
# =============================================================================


@dataclass(frozen=True)
class LogTypeMetadata:
    """
    Metadata describing a registered log type.

    This immutable class stores all information needed to
    generate and format a specific log type.

    Attributes:
        name: Unique identifier (e.g., "player.login")
        category: Which category this log belongs to
        severity: Default severity level
        recurrence: How often this log type typically fires
        description: Human-readable description
        text_template: Printf-style template for text output
        tags: Optional tags for filtering/organization
    """

    name: str
    category: LogCategory
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
    This is the main output type of the log generator.

    Attributes:
        log_type: The registered log type name
        timestamp: When the event occurred
        severity: Severity level
        category: Which category this belongs to
        data: Log-specific data dictionary
        server_id: Optional server identifier
        session_id: Optional session identifier
    """

    log_type: str
    timestamp: datetime
    severity: LogSeverity
    category: LogCategory
    data: Dict[str, Any]
    server_id: Optional[str] = None
    session_id: Optional[str] = None

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for serialization."""
        result: Dict[str, Any] = {
            "log_type": self.log_type,
            "timestamp": self.timestamp.isoformat(),
            "severity": self.severity.name,
            "category": self.category.name,
            **self.data,
        }
        if self.server_id:
            result["server_id"] = self.server_id
        if self.session_id:
            result["session_id"] = self.session_id
        return result


@dataclass
class PlayerInfo:
    """
    Information about a player character.

    Used for generating player-related log entries.
    """

    username: str
    character_name: str
    level: int
    character_class: str
    race: str
    faction: Faction
    guild: Optional[str] = None
    zone: Optional[str] = None
    ip_address: Optional[str] = None
    session_id: Optional[str] = None

    def __str__(self) -> str:
        return f"{self.character_name} (Lv.{self.level} {self.race} {self.character_class})"


@dataclass
class ItemInfo:
    """
    Information about a game item.

    Used for generating item-related log entries.
    """

    item_id: int
    name: str
    rarity: ItemRarity
    item_type: str
    level: int
    value: int  # Gold value
    stackable: bool = True
    max_stack: int = 1
    bound: bool = False

    def __str__(self) -> str:
        return f"[{self.rarity.name}] {self.name}"


@dataclass
class CombatEvent:
    """
    Information about a combat event.

    Used for generating combat-related log entries.
    """

    attacker: str
    target: str
    skill: str
    damage: int
    damage_type: DamageType
    result: CombatResult
    is_critical: bool = False
    overkill: int = 0


@dataclass
class QuestInfo:
    """
    Information about a quest.

    Used for generating quest-related log entries.
    """

    quest_id: int
    name: str
    level: int
    zone: str
    xp_reward: int
    gold_reward: int
    objectives: List[str] = field(default_factory=list)


@dataclass
class GuildInfo:
    """
    Information about a guild.

    Used for generating guild-related log entries.
    """

    guild_id: int
    name: str
    faction: Faction
    level: int
    member_count: int
    leader: str


@dataclass
class ServerMetrics:
    """
    Server performance metrics.

    Used for generating server performance log entries.
    """

    cpu_percent: float
    memory_percent: float
    memory_used_mb: int
    memory_total_mb: int
    player_count: int
    entity_count: int
    tick_time_ms: float
    tps: int  # Ticks per second


@dataclass
class NetworkMetrics:
    """
    Network performance metrics.

    Used for generating network-related log entries.
    """

    latency_ms: int
    packets_in: int
    packets_out: int
    bytes_in: int
    bytes_out: int
    packet_loss_percent: float


# =============================================================================
# PROTOCOLS (for dependency injection)
# =============================================================================


class FormatterProtocol(Protocol):
    """
    Protocol defining the log formatter interface.

    All formatters must implement this interface.
    """

    def format(self, entry: LogEntry) -> str:
        """Format a single log entry."""
        ...

    def format_batch(self, entries: List[LogEntry]) -> str:
        """Format multiple log entries."""
        ...


class OutputHandlerProtocol(Protocol):
    """
    Protocol defining the output handler interface.

    All output handlers must implement this interface.
    """

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
