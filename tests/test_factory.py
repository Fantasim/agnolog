"""
Tests for mmofakelog.core.factory module.

Tests the LogFactory class for creating log entries.
"""

import pytest
from datetime import datetime

from mmofakelog.core.factory import LogFactory
from mmofakelog.core.registry import LogTypeRegistry
from mmofakelog.core.types import (
    LogCategory,
    LogEntry,
    LogSeverity,
    LogTypeMetadata,
    RecurrencePattern,
)
from mmofakelog.core.errors import LogTypeNotFoundError, GeneratorNotFoundError
from mmofakelog.generators.base import BaseLogGenerator


class SimpleGenerator(BaseLogGenerator):
    """Simple generator for testing."""

    def _generate_data(self, **kwargs):
        return {
            "message": kwargs.get("message", "default message"),
            "value": kwargs.get("value", 100),
        }


@pytest.fixture
def factory_registry(reset_registry):
    """Create a registry with test types."""
    registry = LogTypeRegistry()

    # Register a test type
    metadata = LogTypeMetadata(
        name="test.simple",
        category=LogCategory.PLAYER,
        severity=LogSeverity.INFO,
        recurrence=RecurrencePattern.NORMAL,
        description="Simple test type",
        text_template="[{timestamp}] TEST: {message}",
    )
    registry.register("test.simple", metadata, SimpleGenerator)

    return registry


@pytest.fixture
def factory(factory_registry):
    """Create a factory with test registry."""
    return LogFactory(registry=factory_registry)


class TestLogFactoryBasic:
    """Basic tests for LogFactory."""

    def test_create_with_defaults(self, factory):
        """Should create entry with defaults."""
        entry = factory.create("test.simple")

        assert entry is not None
        assert entry.log_type == "test.simple"
        assert entry.severity == LogSeverity.INFO
        assert entry.category == LogCategory.PLAYER
        assert "message" in entry.data

    def test_create_with_timestamp(self, factory):
        """Should use provided timestamp."""
        timestamp = datetime(2024, 1, 15, 12, 30, 45)
        entry = factory.create("test.simple", timestamp=timestamp)

        assert entry.timestamp == timestamp

    def test_create_with_server_id(self, factory_registry):
        """Should include server_id."""
        factory = LogFactory(registry=factory_registry, server_id="test-server")
        entry = factory.create("test.simple")

        assert entry.server_id == "test-server"

    def test_create_with_session_id(self, factory):
        """Should include session_id."""
        entry = factory.create("test.simple", session_id="sess-123")

        assert entry.session_id == "sess-123"

    def test_create_unknown_type_returns_none(self, factory):
        """Should return None for unknown type."""
        entry = factory.create("unknown.type")
        assert entry is None

    def test_create_or_raise_unknown_type(self, factory):
        """Should raise for unknown type."""
        with pytest.raises(LogTypeNotFoundError):
            factory.create_or_raise("unknown.type")

    def test_create_with_kwargs(self, factory):
        """Should pass kwargs to generator."""
        entry = factory.create("test.simple", message="custom message")

        assert entry.data["message"] == "custom message"


class TestLogFactoryBatch:
    """Tests for batch creation."""

    def test_create_batch(self, factory):
        """Should create multiple entries."""
        entries = factory.create_batch("test.simple", count=5)

        assert len(entries) == 5
        assert all(isinstance(e, LogEntry) for e in entries)

    def test_create_batch_unknown_type(self, factory):
        """Should return empty list for unknown type."""
        entries = factory.create_batch("unknown.type", count=5)
        assert entries == []

    def test_create_batch_with_kwargs(self, factory):
        """Should pass kwargs to all entries."""
        entries = factory.create_batch("test.simple", count=3, message="batch")

        assert all(e.data["message"] == "batch" for e in entries)


class TestLogFactoryRandom:
    """Tests for random creation."""

    def test_create_random(self, factory):
        """Should create random entry."""
        entry = factory.create_random()

        assert entry is not None
        assert isinstance(entry, LogEntry)

    def test_create_random_with_category(self, factory):
        """Should respect category filter."""
        entry = factory.create_random(category=LogCategory.PLAYER)

        assert entry is not None
        assert entry.category == LogCategory.PLAYER

    def test_create_random_with_recurrence(self, factory):
        """Should respect recurrence filter."""
        entry = factory.create_random(recurrence=RecurrencePattern.NORMAL)

        # Entry should exist
        assert entry is not None


class TestLogFactoryCache:
    """Tests for generator caching."""

    def test_generators_are_cached(self, factory):
        """Should cache generator instances."""
        factory.create("test.simple")
        factory.create("test.simple")

        # Should only have one instance
        assert len(factory._generator_instances) == 1

    def test_clear_cache(self, factory):
        """Should clear generator cache."""
        factory.create("test.simple")
        assert len(factory._generator_instances) == 1

        factory.clear_cache()
        assert len(factory._generator_instances) == 0


class TestLogFactoryHelpers:
    """Tests for helper methods."""

    def test_get_available_types(self, factory):
        """Should return available types."""
        types = factory.get_available_types()

        assert "test.simple" in types

    def test_get_types_by_category(self, factory):
        """Should filter types by category."""
        types = factory.get_types_by_category(LogCategory.PLAYER)

        assert "test.simple" in types

    def test_type_count(self, factory):
        """Should return type count."""
        assert factory.type_count >= 1

    def test_get_metadata(self, factory):
        """Should return metadata."""
        metadata = factory.get_metadata("test.simple")

        assert metadata is not None
        assert metadata.name == "test.simple"

    def test_get_metadata_not_found(self, factory):
        """Should return None for unknown type."""
        metadata = factory.get_metadata("unknown.type")
        assert metadata is None


class TestLogFactoryWithPopulatedRegistry:
    """Tests with all generators registered."""

    def test_create_player_login(self, populated_registry):
        """Should create player login entry."""
        factory = LogFactory(registry=populated_registry)
        entry = factory.create("player.login")

        assert entry is not None
        assert entry.log_type == "player.login"
        assert "username" in entry.data or "character_name" in entry.data

    def test_create_combat_damage(self, populated_registry):
        """Should create combat damage entry."""
        factory = LogFactory(registry=populated_registry)
        entry = factory.create("combat.damage_dealt")

        assert entry is not None
        assert entry.log_type == "combat.damage_dealt"

    def test_create_server_start(self, populated_registry):
        """Should create server start entry."""
        factory = LogFactory(registry=populated_registry)
        entry = factory.create("server.start")

        assert entry is not None
        assert entry.log_type == "server.start"

    def test_create_many_types(self, populated_registry):
        """Should be able to create many different types."""
        factory = LogFactory(registry=populated_registry)

        types_to_test = [
            "player.login",
            "player.logout",
            "server.start",
            "security.login_failed",
            "economy.gold_gain",
            "combat.damage_dealt",
            "technical.connection_open",
        ]

        for log_type in types_to_test:
            entry = factory.create(log_type)
            assert entry is not None, f"Failed to create {log_type}"
            assert entry.log_type == log_type
