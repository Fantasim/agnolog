"""
Scheduling module for realistic log generation timing.

Provides schedulers that generate logs with realistic recurrence
patterns, simulating actual server behavior.

Usage:
    from mmofakelog import LogFactory
    from mmofakelog.scheduling import LogScheduler

    factory = LogFactory()
    scheduler = LogScheduler(factory)
    scheduler.enable_log_types()

    for entry in scheduler.generate_range(start, end, max_logs=1000):
        print(entry)
"""

from mmofakelog.scheduling.scheduler import LogScheduler
from mmofakelog.scheduling.patterns import get_recurrence_rate, RecurrenceCalculator

__all__ = [
    "LogScheduler",
    "get_recurrence_rate",
    "RecurrenceCalculator",
]
