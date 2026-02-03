"""
Log scheduler for generating logs with realistic timing.

Uses a priority queue to maintain upcoming events and generates
new events based on their frequency patterns.
"""

import heapq
import random
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from typing import Dict, Iterator, List, Optional, Set

from mmofakelog.core.factory import LogFactory
from mmofakelog.core.registry import LogTypeRegistry, get_registry
from mmofakelog.core.types import LogEntry, RecurrencePattern
from mmofakelog.logutils import InternalLoggerMixin
from mmofakelog.scheduling.patterns import RecurrenceCalculator


@dataclass(order=True)
class ScheduledEvent:
    """An event scheduled for generation."""

    timestamp: datetime
    log_type: str = field(compare=False)
    priority: int = field(default=0, compare=False)


class LogScheduler(InternalLoggerMixin):
    """
    Schedules log generation based on realistic recurrence patterns.

    Uses a priority queue to maintain upcoming events and generates
    new events based on their frequency patterns. Supports filtering
    by category and log type.

    Usage:
        factory = LogFactory()
        scheduler = LogScheduler(factory)
        scheduler.enable_log_types()  # Enable all

        for entry in scheduler.generate_range(start, end, max_logs=1000):
            print(entry)
    """

    def __init__(
        self,
        factory: LogFactory,
        registry: Optional[LogTypeRegistry] = None,
        time_scale: float = 1.0,
    ) -> None:
        """
        Initialize scheduler.

        Args:
            factory: Log factory for creating entries
            registry: Log type registry (uses singleton if None)
            time_scale: Time multiplier (0.5 = 2x speed, 2.0 = half speed)
        """
        self._factory = factory
        self._registry = registry or get_registry()
        self._time_scale = time_scale
        self._calculator = RecurrenceCalculator(time_scale)
        self._event_queue: List[ScheduledEvent] = []
        self._enabled_types: Set[str] = set()
        self._type_patterns: Dict[str, RecurrencePattern] = {}

    def enable_log_types(
        self,
        log_types: Optional[List[str]] = None,
        categories: Optional[List[str]] = None,
    ) -> None:
        """
        Enable specific log types for generation.

        Args:
            log_types: List of log types to enable (all if None)
            categories: Optional category filter
        """
        all_types = self._registry.all_types()

        if log_types is not None:
            self._enabled_types = set(log_types)
        else:
            self._enabled_types = set(all_types)

        # Apply category filter if provided
        if categories is not None:
            category_set = set(categories)
            self._enabled_types = {
                t for t in self._enabled_types
                if self._registry.get_metadata(t).category in category_set  # type: ignore
            }

        # Cache patterns for enabled types
        self._type_patterns = {}
        for log_type in self._enabled_types:
            metadata = self._registry.get_metadata(log_type)
            if metadata:
                self._type_patterns[log_type] = metadata.recurrence

        self._log_info(f"Enabled {len(self._enabled_types)} log types")

    def disable_log_types(self, log_types: List[str]) -> None:
        """
        Disable specific log types.

        Args:
            log_types: List of log types to disable
        """
        for log_type in log_types:
            self._enabled_types.discard(log_type)
            self._type_patterns.pop(log_type, None)

    def _schedule_next(self, log_type: str, after: datetime) -> None:
        """Schedule the next occurrence of a log type."""
        if log_type not in self._type_patterns:
            return

        pattern = self._type_patterns[log_type]
        interval = self._calculator.get_interval(pattern)
        next_time = after + interval

        heapq.heappush(
            self._event_queue,
            ScheduledEvent(timestamp=next_time, log_type=log_type),
        )

    def initialize(self, start_time: datetime) -> None:
        """
        Initialize the scheduler with starting events.

        Seeds the event queue with initial events for all enabled types.

        Args:
            start_time: When to start generating logs
        """
        self._event_queue.clear()

        for log_type in self._enabled_types:
            # Add small random offset to avoid all events at same time
            offset = timedelta(seconds=random.random() * 10)
            self._schedule_next(log_type, start_time + offset)

        self._log_debug(f"Initialized scheduler with {len(self._event_queue)} events")

    def generate_range(
        self,
        start_time: datetime,
        end_time: datetime,
        max_logs: Optional[int] = None,
    ) -> Iterator[LogEntry]:
        """
        Generate logs within a time range.

        Args:
            start_time: Start of time range
            end_time: End of time range
            max_logs: Maximum number of logs to generate

        Yields:
            LogEntry objects in chronological order
        """
        if not self._enabled_types:
            self._log_warning("No log types enabled, enabling all")
            self.enable_log_types()

        self.initialize(start_time)
        count = 0

        while self._event_queue:
            if max_logs and count >= max_logs:
                break

            event = heapq.heappop(self._event_queue)

            if event.timestamp > end_time:
                break

            # Generate the log entry
            entry = self._factory.create(
                event.log_type,
                timestamp=event.timestamp,
            )

            if entry:
                yield entry
                count += 1

            # Schedule next occurrence
            self._schedule_next(event.log_type, event.timestamp)

        self._log_info(f"Generated {count} logs")

    def generate_count(
        self,
        count: int,
        start_time: Optional[datetime] = None,
    ) -> Iterator[LogEntry]:
        """
        Generate a specific number of logs.

        Args:
            count: Number of logs to generate
            start_time: Optional start time (uses now if None)

        Yields:
            LogEntry objects in chronological order
        """
        if start_time is None:
            start_time = datetime.now()

        # Set a very far end time
        end_time = start_time + timedelta(days=365)

        yield from self.generate_range(start_time, end_time, max_logs=count)

    def generate_one(
        self,
        log_type: Optional[str] = None,
        timestamp: Optional[datetime] = None,
    ) -> Optional[LogEntry]:
        """
        Generate a single log entry.

        Args:
            log_type: Specific log type (random if None)
            timestamp: Optional timestamp (uses now if None)

        Returns:
            Generated LogEntry or None
        """
        if timestamp is None:
            timestamp = datetime.now()

        if log_type is None:
            if self._type_patterns:
                log_type = self._calculator.get_weighted_log_type(self._type_patterns)
            else:
                log_type = random.choice(list(self._enabled_types or self._registry.all_types()))

        return self._factory.create(log_type, timestamp=timestamp)

    def get_enabled_types(self) -> List[str]:
        """Get list of enabled log types."""
        return list(self._enabled_types)

    def get_type_count(self) -> int:
        """Get number of enabled log types."""
        return len(self._enabled_types)

    @property
    def time_scale(self) -> float:
        """Get the current time scale."""
        return self._time_scale

    @time_scale.setter
    def time_scale(self, value: float) -> None:
        """Set the time scale."""
        if value <= 0:
            raise ValueError("Time scale must be positive")
        self._time_scale = value
        self._calculator.time_scale = value

    def __repr__(self) -> str:
        return (
            f"LogScheduler(enabled_types={len(self._enabled_types)}, "
            f"time_scale={self._time_scale})"
        )
