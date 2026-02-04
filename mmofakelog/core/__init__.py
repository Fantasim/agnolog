"""
Core module containing fundamental types, constants, errors, and patterns.

This module provides:
- constants: All magic numbers and configuration values
- errors: All custom exception types
- types: Enums, dataclasses, and type definitions
- registry: Log type registration system
- factory: Log entry creation
- config: Configuration management
"""

from mmofakelog.core.constants import VERSION
from mmofakelog.core.errors import MMOFakeLogError
from mmofakelog.core.types import (
    LogEntry,
    LogFormat,
    LogSeverity,
    LogTypeMetadata,
    RecurrencePattern,
)

__all__ = [
    "VERSION",
    "MMOFakeLogError",
    "LogSeverity",
    "LogFormat",
    "RecurrencePattern",
    "LogTypeMetadata",
    "LogEntry",
]
