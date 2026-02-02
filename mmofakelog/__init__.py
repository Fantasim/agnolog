"""
MMORPG Fake Log Generator

A Python library for generating realistic MMORPG server logs
for testing, development, and simulation purposes.

Example usage:
    from mmofakelog import LogFactory, LogScheduler
    from mmofakelog.formatters import JSONFormatter

    factory = LogFactory()
    scheduler = LogScheduler(factory)
    scheduler.enable_log_types()

    for entry in scheduler.generate_range(start, end, max_logs=100):
        print(JSONFormatter().format(entry))
"""

from mmofakelog.core.constants import VERSION

__version__ = VERSION
__all__ = [
    "__version__",
]
