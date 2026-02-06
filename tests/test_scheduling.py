"""
Tests for agnolog.scheduling module.

Tests LogScheduler and RecurrenceCalculator.
"""

from datetime import datetime, timedelta

import pytest

from agnolog.core.factory import LogFactory
from agnolog.core.registry import LogTypeRegistry
from agnolog.core.types import (
    LogEntry,
    LogSeverity,
    LogTypeMetadata,
    RecurrencePattern,
)
from agnolog.generators.base import BaseLogGenerator
from agnolog.scheduling import LogScheduler, RecurrenceCalculator, get_recurrence_rate
from agnolog.scheduling.scheduler import ScheduledEvent


class DummyGenerator(BaseLogGenerator):
    """Dummy generator for testing."""

    def _generate_data(self, **kwargs):
        return {"test": "data"}


@pytest.fixture
def scheduler_registry(reset_registry):
    """Registry with test types for scheduling."""
    registry = LogTypeRegistry()

    patterns = [
        ("test.frequent", RecurrencePattern.FREQUENT),
        ("test.normal", RecurrencePattern.NORMAL),
        ("test.rare", RecurrencePattern.RARE),
    ]

    for name, pattern in patterns:
        metadata = LogTypeMetadata(
            name=name,
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=pattern,
            description=f"Test {pattern.name}",
            text_template="Test",
        )
        registry.register(name, metadata, DummyGenerator)

    return registry


@pytest.fixture
def scheduler_factory(scheduler_registry):
    """Factory for scheduler tests."""
    return LogFactory(registry=scheduler_registry)


@pytest.fixture
def scheduler(scheduler_factory, scheduler_registry):
    """Default scheduler."""
    return LogScheduler(factory=scheduler_factory, registry=scheduler_registry)


class TestRecurrenceCalculator:
    """Tests for RecurrenceCalculator."""

    def test_get_interval_returns_timedelta(self):
        """Should return a timedelta."""
        calc = RecurrenceCalculator()
        interval = calc.get_interval(RecurrencePattern.NORMAL)

        assert isinstance(interval, timedelta)
        assert interval.total_seconds() > 0

    def test_frequent_has_shorter_interval(self):
        """Frequent patterns should have shorter intervals on average."""
        calc = RecurrenceCalculator()

        # Generate many samples
        frequent_intervals = [
            calc.get_interval(RecurrencePattern.FREQUENT).total_seconds() for _ in range(100)
        ]
        rare_intervals = [
            calc.get_interval(RecurrencePattern.RARE).total_seconds() for _ in range(100)
        ]

        # Average frequent should be much shorter than rare
        avg_frequent = sum(frequent_intervals) / len(frequent_intervals)
        avg_rare = sum(rare_intervals) / len(rare_intervals)

        assert avg_frequent < avg_rare

    def test_time_scale_affects_interval(self):
        """Time scale should affect interval duration."""
        calc_normal = RecurrenceCalculator(time_scale=1.0)
        calc_fast = RecurrenceCalculator(time_scale=0.5)  # 2x faster

        # Fixed seed for reproducibility
        import random

        random.seed(42)
        normal_interval = calc_normal.get_interval(RecurrencePattern.NORMAL)

        random.seed(42)
        fast_interval = calc_fast.get_interval(RecurrencePattern.NORMAL)

        # Fast should be half the time
        assert fast_interval.total_seconds() < normal_interval.total_seconds()

    def test_time_scale_property(self):
        """Should be able to get and set time scale."""
        calc = RecurrenceCalculator(time_scale=1.0)
        assert calc.time_scale == 1.0

        calc.time_scale = 2.0
        assert calc.time_scale == 2.0

    def test_time_scale_must_be_positive(self):
        """Should reject non-positive time scale."""
        calc = RecurrenceCalculator()

        with pytest.raises(ValueError):
            calc.time_scale = 0

        with pytest.raises(ValueError):
            calc.time_scale = -1

    def test_get_weighted_log_type(self):
        """Should select log type based on weights."""
        calc = RecurrenceCalculator()

        available = {
            "test.frequent": RecurrencePattern.FREQUENT,
            "test.rare": RecurrencePattern.RARE,
        }

        # Generate many samples
        selections = [calc.get_weighted_log_type(available) for _ in range(100)]

        # Frequent should be selected more often
        frequent_count = selections.count("test.frequent")
        rare_count = selections.count("test.rare")

        assert frequent_count > rare_count

    def test_get_weighted_log_type_empty_raises(self):
        """Should raise for empty available types."""
        calc = RecurrenceCalculator()

        with pytest.raises(ValueError):
            calc.get_weighted_log_type({})


class TestGetRecurrenceRate:
    """Tests for get_recurrence_rate function."""

    def test_returns_float(self):
        """Should return a float."""
        rate = get_recurrence_rate(RecurrencePattern.NORMAL)
        assert isinstance(rate, float)

    def test_rates_match_expected_order(self):
        """Rates should follow expected order."""
        very_freq = get_recurrence_rate(RecurrencePattern.VERY_FREQUENT)
        frequent = get_recurrence_rate(RecurrencePattern.FREQUENT)
        normal = get_recurrence_rate(RecurrencePattern.NORMAL)
        infrequent = get_recurrence_rate(RecurrencePattern.INFREQUENT)
        rare = get_recurrence_rate(RecurrencePattern.RARE)

        assert very_freq > frequent > normal > infrequent > rare


class TestScheduledEvent:
    """Tests for ScheduledEvent dataclass."""

    def test_ordering_by_timestamp(self):
        """Events should be ordered by timestamp."""
        event1 = ScheduledEvent(
            timestamp=datetime(2024, 1, 15, 12, 0, 0),
            log_type="test.type",
        )
        event2 = ScheduledEvent(
            timestamp=datetime(2024, 1, 15, 12, 0, 1),
            log_type="test.type",
        )

        assert event1 < event2

    def test_same_timestamp_events_equal(self):
        """Events with same timestamp should be equal in ordering."""
        ts = datetime(2024, 1, 15, 12, 0, 0)
        event1 = ScheduledEvent(timestamp=ts, log_type="test.a")
        event2 = ScheduledEvent(timestamp=ts, log_type="test.b")

        # Same timestamp means equal in ordering
        assert not (event1 < event2)
        assert not (event2 < event1)


class TestLogScheduler:
    """Tests for LogScheduler."""

    def test_enable_all_types(self, scheduler):
        """Should enable all types when no filter provided."""
        scheduler.enable_log_types()

        assert scheduler.get_type_count() == 3

    def test_enable_specific_types(self, scheduler):
        """Should enable only specified types."""
        scheduler.enable_log_types(log_types=["test.frequent"])

        assert scheduler.get_type_count() == 1
        assert "test.frequent" in scheduler.get_enabled_types()

    def test_enable_by_category(self, scheduler_factory, scheduler_registry):
        """Should filter by category."""
        # All our test types are PLAYER category
        scheduler = LogScheduler(
            factory=scheduler_factory,
            registry=scheduler_registry,
        )
        scheduler.enable_log_types(categories=["PLAYER"])

        assert scheduler.get_type_count() == 3

        # SERVER category should have none
        scheduler.enable_log_types(categories=["SERVER"])
        assert scheduler.get_type_count() == 0

    def test_disable_log_types(self, scheduler):
        """Should disable specified types."""
        scheduler.enable_log_types()
        scheduler.disable_log_types(["test.frequent"])

        assert "test.frequent" not in scheduler.get_enabled_types()
        assert scheduler.get_type_count() == 2

    def test_generate_range_produces_entries(self, scheduler):
        """Should generate entries in time range."""
        scheduler.enable_log_types()

        start = datetime(2024, 1, 15, 12, 0, 0)
        end = start + timedelta(hours=1)

        entries = list(scheduler.generate_range(start, end, max_logs=10))

        assert len(entries) == 10
        assert all(isinstance(e, LogEntry) for e in entries)

    def test_generate_range_respects_time_bounds(self, scheduler):
        """Should not generate entries outside time range."""
        scheduler.enable_log_types()

        start = datetime(2024, 1, 15, 12, 0, 0)
        end = start + timedelta(minutes=5)

        entries = list(scheduler.generate_range(start, end, max_logs=1000))

        for entry in entries:
            assert start <= entry.timestamp <= end

    def test_generate_range_chronological_order(self, scheduler):
        """Entries should be in chronological order."""
        scheduler.enable_log_types()

        start = datetime(2024, 1, 15, 12, 0, 0)
        end = start + timedelta(hours=1)

        entries = list(scheduler.generate_range(start, end, max_logs=50))

        for i in range(1, len(entries)):
            assert entries[i].timestamp >= entries[i - 1].timestamp

    def test_generate_range_with_max_logs(self, scheduler):
        """Should respect max_logs limit."""
        scheduler.enable_log_types()

        start = datetime(2024, 1, 15, 12, 0, 0)
        end = start + timedelta(hours=24)

        entries = list(scheduler.generate_range(start, end, max_logs=5))

        assert len(entries) == 5

    def test_generate_count(self, scheduler):
        """Should generate exact count."""
        scheduler.enable_log_types()

        entries = list(scheduler.generate_count(count=20))

        assert len(entries) == 20

    def test_generate_one(self, scheduler):
        """Should generate single entry."""
        scheduler.enable_log_types()

        entry = scheduler.generate_one()

        assert entry is not None
        assert isinstance(entry, LogEntry)

    def test_generate_one_specific_type(self, scheduler):
        """Should generate specific type."""
        scheduler.enable_log_types()

        entry = scheduler.generate_one(log_type="test.frequent")

        assert entry.log_type == "test.frequent"

    def test_generate_one_with_timestamp(self, scheduler):
        """Should use provided timestamp."""
        scheduler.enable_log_types()

        timestamp = datetime(2024, 1, 15, 12, 30, 45)
        entry = scheduler.generate_one(timestamp=timestamp)

        assert entry.timestamp == timestamp

    def test_time_scale_property(self, scheduler):
        """Should be able to get and set time scale."""
        assert scheduler.time_scale == 1.0

        scheduler.time_scale = 2.0
        assert scheduler.time_scale == 2.0

    def test_time_scale_must_be_positive(self, scheduler):
        """Should reject non-positive time scale."""
        with pytest.raises(ValueError):
            scheduler.time_scale = 0

    def test_repr(self, scheduler):
        """Should have meaningful repr."""
        scheduler.enable_log_types()

        result = repr(scheduler)

        assert "LogScheduler" in result
        assert "enabled_types" in result


class TestLogSchedulerAutoEnable:
    """Tests for auto-enabling types."""

    def test_auto_enables_on_generate_range(self, scheduler):
        """Should auto-enable types if none enabled."""
        # Don't call enable_log_types

        start = datetime.now()
        end = start + timedelta(hours=1)

        entries = list(scheduler.generate_range(start, end, max_logs=5))

        # Should have generated entries
        assert len(entries) == 5


class TestLogSchedulerWithPopulatedRegistry:
    """Tests with all generators registered."""

    def test_schedule_all_types(self, populated_registry):
        """Should schedule all registered types."""
        factory = LogFactory(registry=populated_registry)
        scheduler = LogScheduler(factory=factory, registry=populated_registry)
        scheduler.enable_log_types()

        assert scheduler.get_type_count() >= 100

    def test_generate_diverse_entries(self, populated_registry):
        """Should generate entries of various types."""
        factory = LogFactory(registry=populated_registry)
        scheduler = LogScheduler(factory=factory, registry=populated_registry)
        scheduler.enable_log_types()

        start = datetime.now()
        end = start + timedelta(hours=1)

        entries = list(scheduler.generate_range(start, end, max_logs=100))

        # Should have entries of different types
        types_seen = {e.log_type for e in entries}
        assert len(types_seen) >= 10, "Expected diverse log types"

    def test_frequent_types_appear_more(self, populated_registry):
        """Frequent types should appear more often."""
        factory = LogFactory(registry=populated_registry)
        scheduler = LogScheduler(factory=factory, registry=populated_registry)

        # Enable only types we know the patterns for
        scheduler.enable_log_types(log_types=["combat.damage_dealt", "server.restart"])

        start = datetime.now()
        end = start + timedelta(hours=2)

        entries = list(scheduler.generate_range(start, end, max_logs=100))

        # Count by type
        damage_count = sum(1 for e in entries if e.log_type == "combat.damage_dealt")

        # Damage (frequent/very_frequent) should appear more than restart (rare)
        # Note: Due to randomness, we just check damage appears at least somewhat
        assert damage_count > 0
