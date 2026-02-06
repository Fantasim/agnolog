"""
Recurrence patterns for log generation timing.

Provides utilities for calculating realistic intervals between
log events based on their recurrence patterns.
"""

import random
from datetime import timedelta

from agnolog.core.constants import RECURRENCE_WEIGHTS
from agnolog.core.types import RecurrencePattern


def get_recurrence_rate(pattern: RecurrencePattern) -> float:
    """
    Get the events-per-hour rate for a recurrence pattern.

    Args:
        pattern: The recurrence pattern

    Returns:
        Events per hour (float)
    """
    return RECURRENCE_WEIGHTS.get(pattern.name, 1.0)


class RecurrenceCalculator:
    """
    Calculates intervals between log events.

    Uses exponential distribution for realistic randomness,
    which models the time between independent events well.
    """

    def __init__(self, time_scale: float = 1.0) -> None:
        """
        Initialize calculator.

        Args:
            time_scale: Time multiplier (0.5 = 2x speed, 2.0 = half speed)
        """
        self._time_scale = time_scale

    def get_interval(self, pattern: RecurrencePattern) -> timedelta:
        """
        Calculate the next interval based on pattern.

        Uses exponential distribution for realistic event spacing.

        Args:
            pattern: The recurrence pattern

        Returns:
            Time interval until next event
        """
        # Get events per hour
        events_per_hour = get_recurrence_rate(pattern)

        if events_per_hour <= 0:
            # Very rare event - default to once per day
            mean_interval = 86400.0
        else:
            # Convert events/hour to seconds between events
            mean_interval = 3600.0 / events_per_hour

        # Apply time scale
        mean_interval *= self._time_scale

        # Use exponential distribution
        # This naturally models time between independent events
        interval_seconds = random.expovariate(1.0 / mean_interval)

        # Ensure minimum interval to prevent tight loops
        interval_seconds = max(0.001, interval_seconds)

        return timedelta(seconds=interval_seconds)

    def get_weighted_log_type(
        self,
        available_types: dict[str, RecurrencePattern],
    ) -> str:
        """
        Select a log type weighted by recurrence frequency.

        More frequent log types are more likely to be selected.

        Args:
            available_types: Dict mapping log type names to patterns

        Returns:
            Selected log type name
        """
        if not available_types:
            raise ValueError("No log types available")

        types = list(available_types.keys())
        weights = [get_recurrence_rate(available_types[t]) for t in types]

        # Ensure at least some weight
        weights = [max(0.01, w) for w in weights]

        return random.choices(types, weights=weights, k=1)[0]

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
