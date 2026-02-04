"""
Scheduling module for realistic log generation timing.

Provides schedulers that generate logs with realistic recurrence
patterns, simulating actual server behavior.

Usage:
    from agnolog import LogFactory
    from agnolog.scheduling import LogScheduler

    factory = LogFactory()
    scheduler = LogScheduler(factory)
    scheduler.enable_log_types()

    for entry in scheduler.generate_range(start, end, max_logs=1000):
        print(entry)
"""

from agnolog.scheduling.scheduler import LogScheduler
from agnolog.scheduling.patterns import get_recurrence_rate, RecurrenceCalculator

__all__ = [
    "LogScheduler",
    "get_recurrence_rate",
    "RecurrenceCalculator",
]
