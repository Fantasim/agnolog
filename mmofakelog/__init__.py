"""
MMORPG Fake Log Generator

A Python library for generating realistic MMORPG server logs
for testing, development, and simulation purposes.

Example usage:
    from mmofakelog import LogFactory, LogScheduler
    from mmofakelog.formatters import JSONFormatter
    from datetime import datetime, timedelta

    # Import generators to register them
    from mmofakelog import generators

    factory = LogFactory()
    scheduler = LogScheduler(factory)
    scheduler.enable_log_types()

    start = datetime.now()
    end = start + timedelta(hours=1)

    for entry in scheduler.generate_range(start, end, max_logs=100):
        print(JSONFormatter().format(entry))
"""

from mmofakelog.core.constants import VERSION
from mmofakelog.core.factory import LogFactory
from mmofakelog.core.registry import LogTypeRegistry, get_registry
from mmofakelog.core.types import (
    LogEntry,
    LogFormat,
    LogSeverity,
    RecurrencePattern,
)
from mmofakelog.scheduling import LogScheduler

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
