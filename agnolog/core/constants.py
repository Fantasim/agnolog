"""
Constants for Agnolog - Theme-agnostic Log Generator.

Contains default values and configuration constants.
Theme-specific data is loaded from YAML files.
"""

from typing import Final

# =============================================================================
# VERSION AND METADATA
# =============================================================================
VERSION: Final[str] = "1.0.0"
PACKAGE_NAME: Final[str] = "agnolog"

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
RECURRENCE_WEIGHTS: Final[dict[str, float]] = {
    "VERY_FREQUENT": 3600.0,  # 1 per second average
    "FREQUENT": 300.0,  # 5 per minute average
    "NORMAL": 30.0,  # 0.5 per minute average
    "INFREQUENT": 2.0,  # 2 per hour average
    "RARE": 0.04,  # ~1 per day average
}

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
# INTERNAL LOGGING CONFIGURATION
# =============================================================================
INTERNAL_LOG_FORMAT: Final[str] = "[%(asctime)s] [%(levelname)s] %(name)s: %(message)s"
INTERNAL_LOG_DATE_FORMAT: Final[str] = "%Y-%m-%d %H:%M:%S"
INTERNAL_LOG_LEVEL: Final[str] = "INFO"
INTERNAL_LOGGER_NAME: Final[str] = "agnolog.internal"

# =============================================================================
# LOGHUB CSV FORMAT CONFIGURATION
# =============================================================================
LOGHUB_PLACEHOLDER: Final[str] = "<*>"
LOGHUB_CSV_COLUMNS: Final[tuple[str, ...]] = (
    "LineId",
    "Date",
    "Day",
    "Time",
    "Component",
    "Pid",
    "Content",
    "EventId",
    "EventTemplate",
)
LOGHUB_TEMPLATE_COLUMNS: Final[tuple[str, ...]] = ("EventId", "EventTemplate", "MergeGroups")
