"""
All constants for the MMORPG Fake Log Generator.

This file contains ALL magic numbers, default values, and
configuration constants used throughout the application.
Centralizing constants here ensures easy maintenance and
prevents magic numbers scattered throughout the codebase.
"""

from typing import Dict, Final, List, Tuple

# =============================================================================
# VERSION AND METADATA
# =============================================================================
VERSION: Final[str] = "1.0.0"
PACKAGE_NAME: Final[str] = "mmofakelog"
AUTHOR: Final[str] = "Louis"

# =============================================================================
# DEFAULT CONFIGURATION
# =============================================================================
DEFAULT_OUTPUT_FORMAT: Final[str] = "json"
DEFAULT_LOG_COUNT: Final[int] = 100
DEFAULT_BATCH_SIZE: Final[int] = 1000
DEFAULT_SERVER_ID: Final[str] = "server-01"
DEFAULT_TIMEZONE: Final[str] = "UTC"
DEFAULT_TIME_SCALE: Final[float] = 1.0

# =============================================================================
# RECURRENCE WEIGHTS (events per hour at normal rate)
# These determine how often each log type fires
# =============================================================================
RECURRENCE_WEIGHTS: Final[Dict[str, float]] = {
    "VERY_FREQUENT": 3600.0,    # 1 per second average
    "FREQUENT": 300.0,          # 5 per minute average
    "NORMAL": 30.0,             # 0.5 per minute average
    "INFREQUENT": 2.0,          # 2 per hour average
    "RARE": 0.04,               # ~1 per day average
}

# =============================================================================
# AI CONFIGURATION
# =============================================================================
DEFAULT_AI_MODEL: Final[str] = "gpt-3.5-turbo"
AI_MAX_TOKENS: Final[int] = 100
AI_TEMPERATURE: Final[float] = 0.8
AI_CACHE_TTL: Final[int] = 3600  # 1 hour in seconds
AI_REQUEST_TIMEOUT: Final[int] = 10  # seconds
AI_MAX_RETRIES: Final[int] = 3
AI_RETRY_DELAY: Final[float] = 1.0  # seconds

# =============================================================================
# OUTPUT CONFIGURATION
# =============================================================================
MAX_LOG_LINE_LENGTH: Final[int] = 4096
DEFAULT_TIMESTAMP_FORMAT: Final[str] = "%Y-%m-%d %H:%M:%S.%f"
SHORT_TIMESTAMP_FORMAT: Final[str] = "%Y-%m-%d %H:%M:%S"
JSON_INDENT: Final[int] = 2
FILE_ROTATION_SIZE: Final[int] = 10 * 1024 * 1024  # 10MB
FILE_ROTATION_COUNT: Final[int] = 5
FILE_ENCODING: Final[str] = "utf-8"

# =============================================================================
# GAME WORLD CONSTANTS
# =============================================================================
MAX_PLAYER_LEVEL: Final[int] = 60
MIN_PLAYER_LEVEL: Final[int] = 1
MAX_GOLD: Final[int] = 999_999_999
MIN_GOLD: Final[int] = 0
MAX_ITEM_STACK: Final[int] = 999
MAX_PARTY_SIZE: Final[int] = 5
MAX_RAID_SIZE: Final[int] = 40
MAX_GUILD_SIZE: Final[int] = 1000
MAX_FRIENDS: Final[int] = 100
MAX_INVENTORY_SLOTS: Final[int] = 120

# Session duration bounds (seconds)
MIN_SESSION_DURATION: Final[int] = 60  # 1 minute
MAX_SESSION_DURATION: Final[int] = 28800  # 8 hours
TYPICAL_SESSION_DURATION: Final[int] = 3600  # 1 hour

# =============================================================================
# NETWORK CONSTANTS
# =============================================================================
MIN_LATENCY_MS: Final[int] = 10
MAX_LATENCY_MS: Final[int] = 500
TYPICAL_LATENCY_MS: Final[int] = 50
SPIKE_LATENCY_MS: Final[int] = 1000
PACKET_SIZE_MIN: Final[int] = 32
PACKET_SIZE_MAX: Final[int] = 4096
CONNECTION_TIMEOUT_MS: Final[int] = 30000

# =============================================================================
# SERVER PERFORMANCE CONSTANTS
# =============================================================================
MIN_CPU_PERCENT: Final[float] = 5.0
MAX_CPU_PERCENT: Final[float] = 95.0
TYPICAL_CPU_PERCENT: Final[float] = 35.0
MIN_MEMORY_PERCENT: Final[float] = 20.0
MAX_MEMORY_PERCENT: Final[float] = 90.0
TYPICAL_MEMORY_PERCENT: Final[float] = 60.0
MIN_TPS: Final[int] = 10  # Ticks per second
MAX_TPS: Final[int] = 20
TYPICAL_TPS: Final[int] = 20
TICK_TIME_MS_MIN: Final[int] = 10
TICK_TIME_MS_MAX: Final[int] = 100

# =============================================================================
# COMBAT CONSTANTS
# =============================================================================
MIN_DAMAGE: Final[int] = 1
MAX_DAMAGE: Final[int] = 50000
MIN_HEAL: Final[int] = 1
MAX_HEAL: Final[int] = 30000
CRIT_MULTIPLIER: Final[float] = 2.0
CRIT_CHANCE: Final[float] = 0.05
DODGE_CHANCE: Final[float] = 0.05
PARRY_CHANCE: Final[float] = 0.05
BLOCK_CHANCE: Final[float] = 0.10
MIN_BUFF_DURATION: Final[int] = 5  # seconds
MAX_BUFF_DURATION: Final[int] = 3600  # 1 hour
MIN_MOB_XP: Final[int] = 10
MAX_MOB_XP: Final[int] = 5000
MIN_QUEST_XP: Final[int] = 100
MAX_QUEST_XP: Final[int] = 50000

# =============================================================================
# ECONOMY CONSTANTS
# =============================================================================
MIN_VENDOR_PRICE: Final[int] = 1
MAX_VENDOR_PRICE: Final[int] = 100000
MIN_AUCTION_PRICE: Final[int] = 1
MAX_AUCTION_PRICE: Final[int] = 10_000_000
AUCTION_FEE_PERCENT: Final[float] = 0.05  # 5%
TRADE_TAX_PERCENT: Final[float] = 0.0  # No trade tax by default
REPAIR_COST_PERCENT: Final[float] = 0.10  # 10% of item value

# =============================================================================
# INTERNAL LOGGING CONFIGURATION
# =============================================================================
INTERNAL_LOG_FORMAT: Final[str] = "[%(asctime)s] [%(levelname)s] %(name)s: %(message)s"
INTERNAL_LOG_DATE_FORMAT: Final[str] = "%Y-%m-%d %H:%M:%S"
INTERNAL_LOG_LEVEL: Final[str] = "INFO"
INTERNAL_LOGGER_NAME: Final[str] = "mmofakelog.internal"

# =============================================================================
# ZONE/AREA NAMES
# =============================================================================
ZONES: Final[Tuple[str, ...]] = (
    # Starting zones
    "Elwynn Forest", "Durotar", "Mulgore", "Teldrassil", "Tirisfal Glades",
    "Dun Morogh", "Eversong Woods", "Azuremyst Isle", "Gilneas", "Kezan",
    # Mid-level zones
    "Westfall", "Redridge Mountains", "Duskwood", "Stranglethorn Vale",
    "The Barrens", "Ashenvale", "Thousand Needles", "Tanaris", "Feralas",
    "Desolace", "Dustwallow Marsh", "Arathi Highlands", "Hillsbrad Foothills",
    # High-level zones
    "Western Plaguelands", "Eastern Plaguelands", "Burning Steppes",
    "Searing Gorge", "Blasted Lands", "Silithus", "Winterspring", "Felwood",
    # Capital cities
    "Stormwind", "Ironforge", "Darnassus", "The Exodar",
    "Orgrimmar", "Thunder Bluff", "Undercity", "Silvermoon City",
    # Dungeons
    "Deadmines", "Wailing Caverns", "Shadowfang Keep", "Scarlet Monastery",
    "Uldaman", "Zul'Farrak", "Maraudon", "Sunken Temple", "Blackrock Depths",
    "Stratholme", "Scholomance", "Dire Maul",
    # Raids
    "Molten Core", "Blackwing Lair", "Temple of Ahn'Qiraj", "Naxxramas",
)

# =============================================================================
# ITEM RARITIES
# =============================================================================
ITEM_RARITIES: Final[Tuple[str, ...]] = (
    "Poor", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Artifact",
)

RARITY_WEIGHTS: Final[Dict[str, float]] = {
    "Poor": 0.10,
    "Common": 0.40,
    "Uncommon": 0.30,
    "Rare": 0.14,
    "Epic": 0.05,
    "Legendary": 0.009,
    "Artifact": 0.001,
}

RARITY_COLORS: Final[Dict[str, str]] = {
    "Poor": "#9d9d9d",
    "Common": "#ffffff",
    "Uncommon": "#1eff00",
    "Rare": "#0070dd",
    "Epic": "#a335ee",
    "Legendary": "#ff8000",
    "Artifact": "#e6cc80",
}

# =============================================================================
# CHARACTER CLASSES
# =============================================================================
CHARACTER_CLASSES: Final[Tuple[str, ...]] = (
    "Warrior", "Paladin", "Hunter", "Rogue", "Priest",
    "Shaman", "Mage", "Warlock", "Druid", "Death Knight",
    "Monk", "Demon Hunter",
)

CLASS_ROLES: Final[Dict[str, List[str]]] = {
    "Warrior": ["Tank", "DPS"],
    "Paladin": ["Tank", "Healer", "DPS"],
    "Hunter": ["DPS"],
    "Rogue": ["DPS"],
    "Priest": ["Healer", "DPS"],
    "Shaman": ["Healer", "DPS"],
    "Mage": ["DPS"],
    "Warlock": ["DPS"],
    "Druid": ["Tank", "Healer", "DPS"],
    "Death Knight": ["Tank", "DPS"],
    "Monk": ["Tank", "Healer", "DPS"],
    "Demon Hunter": ["Tank", "DPS"],
}

# =============================================================================
# CHARACTER RACES
# =============================================================================
CHARACTER_RACES: Final[Tuple[str, ...]] = (
    # Alliance
    "Human", "Dwarf", "Night Elf", "Gnome", "Draenei", "Worgen", "Pandaren",
    # Horde
    "Orc", "Undead", "Tauren", "Troll", "Blood Elf", "Goblin",
)

FACTION_RACES: Final[Dict[str, Tuple[str, ...]]] = {
    "Alliance": ("Human", "Dwarf", "Night Elf", "Gnome", "Draenei", "Worgen"),
    "Horde": ("Orc", "Undead", "Tauren", "Troll", "Blood Elf", "Goblin"),
    "Neutral": ("Pandaren",),
}

# =============================================================================
# SERVER REGIONS
# =============================================================================
SERVER_REGIONS: Final[Tuple[str, ...]] = (
    "NA-West", "NA-East", "EU-West", "EU-East",
    "Asia-Pacific", "Oceania", "South America", "Korea",
)

# =============================================================================
# CHAT CHANNELS
# =============================================================================
CHAT_CHANNELS: Final[Tuple[str, ...]] = (
    "say", "yell", "whisper", "party", "raid",
    "guild", "officer", "trade", "general", "lfg",
)

# =============================================================================
# LOGOUT REASONS
# =============================================================================
LOGOUT_REASONS: Final[Tuple[str, ...]] = (
    "voluntary", "timeout", "kick", "server_shutdown",
    "connection_lost", "client_crash", "maintenance",
)

# =============================================================================
# ADMIN ACTIONS
# =============================================================================
ADMIN_ACTIONS: Final[Tuple[str, ...]] = (
    "ban", "unban", "mute", "unmute", "kick", "warn",
    "teleport", "summon", "grant_item", "remove_item",
    "set_level", "add_gold", "remove_gold", "freeze", "unfreeze",
)

# =============================================================================
# SECURITY RISK LEVELS
# =============================================================================
RISK_LEVELS: Final[Tuple[str, ...]] = (
    "low", "medium", "high", "critical",
)

RISK_SCORE_THRESHOLDS: Final[Dict[str, int]] = {
    "low": 25,
    "medium": 50,
    "high": 75,
    "critical": 90,
}

# =============================================================================
# ERROR CODES
# =============================================================================
ERROR_CODES: Final[Dict[str, str]] = {
    "E001": "Connection timeout",
    "E002": "Authentication failed",
    "E003": "Character not found",
    "E004": "Invalid packet format",
    "E005": "Database connection lost",
    "E006": "Rate limit exceeded",
    "E007": "Insufficient permissions",
    "E008": "Resource not found",
    "E009": "Internal server error",
    "E010": "Service unavailable",
    "E011": "Invalid session",
    "E012": "Duplicate request",
    "E013": "Inventory full",
    "E014": "Insufficient funds",
    "E015": "Item not tradeable",
    "E016": "Target not found",
    "E017": "Cooldown active",
    "E018": "Level requirement not met",
    "E019": "Quest already completed",
    "E020": "Guild full",
}

# =============================================================================
# PACKET TYPES
# =============================================================================
PACKET_TYPES: Final[Tuple[str, ...]] = (
    "CMSG_AUTH", "SMSG_AUTH_RESPONSE", "CMSG_HEARTBEAT", "SMSG_HEARTBEAT",
    "CMSG_MOVE", "SMSG_MOVE", "CMSG_CHAT", "SMSG_CHAT",
    "CMSG_SPELL_CAST", "SMSG_SPELL_START", "SMSG_SPELL_GO",
    "CMSG_ITEM_USE", "SMSG_ITEM_UPDATE", "CMSG_LOOT", "SMSG_LOOT_RESPONSE",
    "CMSG_TRADE_INITIATE", "SMSG_TRADE_STATUS", "CMSG_GUILD_ROSTER",
    "SMSG_GUILD_ROSTER", "CMSG_QUEST_LOG", "SMSG_QUEST_UPDATE",
    "CMSG_AUCTION_LIST", "SMSG_AUCTION_LIST", "CMSG_MAIL_LIST", "SMSG_MAIL_LIST",
)

# =============================================================================
# DATABASE QUERY TYPES
# =============================================================================
DB_QUERY_TYPES: Final[Tuple[str, ...]] = (
    "SELECT", "INSERT", "UPDATE", "DELETE",
    "TRANSACTION", "STORED_PROC", "INDEX_SCAN", "TABLE_SCAN",
)

# =============================================================================
# CACHE TYPES
# =============================================================================
CACHE_TYPES: Final[Tuple[str, ...]] = (
    "player_data", "item_data", "quest_data", "guild_data",
    "zone_data", "session_data", "auction_data", "leaderboard",
)
