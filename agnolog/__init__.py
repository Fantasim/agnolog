"""
MMORPG Fake Log Generator

A Python library for generating realistic MMORPG server logs
for testing, development, and simulation purposes.

Example usage:
    from agnolog import LogFactory, LogScheduler
    from agnolog.formatters import JSONFormatter
    from datetime import datetime, timedelta

    # Import generators to register them
    from agnolog import generators

    factory = LogFactory()
    scheduler = LogScheduler(factory)
    scheduler.enable_log_types()

    start = datetime.now()
    end = start + timedelta(hours=1)

    for entry in scheduler.generate_range(start, end, max_logs=100):
        print(JSONFormatter().format(entry))
"""

from agnolog.core.constants import VERSION
from agnolog.core.factory import LogFactory
from agnolog.core.registry import LogTypeRegistry, get_registry
from agnolog.core.types import (
    LogEntry,
    LogFormat,
    LogSeverity,
    RecurrencePattern,
)
from agnolog.scheduling import LogScheduler

__version__ = VERSION
__all__ = [
    "__version__",
    "LogFactory",
    "LogScheduler",
    "LogTypeRegistry",
    "get_registry",
    "LogEntry",
    "LogFormat",
    "LogSeverity",
    "RecurrencePattern",
]
