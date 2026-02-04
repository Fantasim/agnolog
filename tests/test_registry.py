"""
Tests for mmofakelog.core.registry module.

Tests the LogTypeRegistry class and register_log_type decorator.
"""

import pytest
from mmofakelog.core.registry import (
    LogTypeRegistry,
    register_log_type,
    get_registry,
)
from mmofakelog.core.types import (
    LogSeverity,
    LogTypeMetadata,
    RecurrencePattern,
)
from mmofakelog.core.errors import (
    DuplicateLogTypeError,
    InvalidLogTypeError,
    LogTypeNotFoundError,
)
from mmofakelog.generators.base import BaseLogGenerator


class DummyGenerator(BaseLogGenerator):
    """Dummy generator for testing."""

    def _generate_data(self, **kwargs):
        return {"test": "data"}


class TestLogTypeRegistry:
    """Tests for LogTypeRegistry class."""

    def test_singleton_pattern(self, reset_registry):
        """Registry should be a singleton."""
        registry1 = LogTypeRegistry()
        registry2 = LogTypeRegistry()
        assert registry1 is registry2

    def test_reset(self, reset_registry):
        """Reset should create new instance."""
        registry1 = LogTypeRegistry()
        LogTypeRegistry.reset()
        registry2 = LogTypeRegistry()
        assert registry1 is not registry2

    def test_register_valid_type(self, empty_registry):
        """Should register valid log type."""
        metadata = LogTypeMetadata(
            name="test.type",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test type",
            text_template="Test",
        )
        empty_registry.register("test.type", metadata, DummyGenerator)

        assert empty_registry.is_registered("test.type")
        assert empty_registry.count() == 1

    def test_register_duplicate_raises(self, empty_registry):
        """Should raise on duplicate registration."""
        metadata = LogTypeMetadata(
            name="test.type",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test type",
            text_template="Test",
        )
        empty_registry.register("test.type", metadata, DummyGenerator)

        with pytest.raises(DuplicateLogTypeError):
            empty_registry.register("test.type", metadata, DummyGenerator)

    def test_register_empty_name_raises(self, empty_registry):
        """Should raise on empty name."""
        metadata = LogTypeMetadata(
            name="test.type",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test type",
            text_template="Test",
        )
        with pytest.raises(InvalidLogTypeError):
            empty_registry.register("", metadata, DummyGenerator)

    def test_register_non_namespaced_raises(self, empty_registry):
        """Should raise on non-namespaced name."""
        metadata = LogTypeMetadata(
            name="test.type",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test type",
            text_template="Test",
        )
        with pytest.raises(InvalidLogTypeError):
            empty_registry.register("invalid", metadata, DummyGenerator)

    def test_unregister(self, empty_registry):
        """Should unregister existing type."""
        metadata = LogTypeMetadata(
            name="test.type",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test type",
            text_template="Test",
        )
        empty_registry.register("test.type", metadata, DummyGenerator)

        result = empty_registry.unregister("test.type")
        assert result is True
        assert not empty_registry.is_registered("test.type")

    def test_unregister_nonexistent(self, empty_registry):
        """Should return False for nonexistent type."""
        result = empty_registry.unregister("nonexistent.type")
        assert result is False

    def test_get_metadata(self, empty_registry):
        """Should return metadata for registered type."""
        metadata = LogTypeMetadata(
            name="test.type",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test type",
            text_template="Test",
        )
        empty_registry.register("test.type", metadata, DummyGenerator)

        result = empty_registry.get_metadata("test.type")
        assert result == metadata

    def test_get_metadata_not_found(self, empty_registry):
        """Should return None for unknown type."""
        result = empty_registry.get_metadata("unknown.type")
        assert result is None

    def test_get_metadata_or_raise(self, empty_registry):
        """Should raise for unknown type."""
        with pytest.raises(LogTypeNotFoundError):
            empty_registry.get_metadata_or_raise("unknown.type")

    def test_get_generator(self, empty_registry):
        """Should return generator class."""
        metadata = LogTypeMetadata(
            name="test.type",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test type",
            text_template="Test",
        )
        empty_registry.register("test.type", metadata, DummyGenerator)

        result = empty_registry.get_generator("test.type")
        assert result == DummyGenerator

    def test_get_generator_not_found(self, empty_registry):
        """Should return None for unknown type."""
        result = empty_registry.get_generator("unknown.type")
        assert result is None

    def test_get_generator_or_raise(self, empty_registry):
        """Should raise for unknown type."""
        with pytest.raises(LogTypeNotFoundError):
            empty_registry.get_generator_or_raise("unknown.type")

    def test_get_by_category(self, empty_registry):
        """Should filter by category."""
        for i, cat in enumerate(["PLAYER", "SERVER", "PLAYER"]):
            metadata = LogTypeMetadata(
                name=f"test.type{i}",
                category=cat,
                severity=LogSeverity.INFO,
                recurrence=RecurrencePattern.NORMAL,
                description="Test",
                text_template="Test",
            )
            empty_registry.register(f"test.type{i}", metadata, DummyGenerator)

        player_types = empty_registry.get_by_category("PLAYER")
        assert len(player_types) == 2
        assert "test.type0" in player_types
        assert "test.type2" in player_types

    def test_get_by_recurrence(self, empty_registry):
        """Should filter by recurrence pattern."""
        patterns = [RecurrencePattern.NORMAL, RecurrencePattern.RARE, RecurrencePattern.NORMAL]
        for i, pattern in enumerate(patterns):
            metadata = LogTypeMetadata(
                name=f"test.type{i}",
                category="PLAYER",
                severity=LogSeverity.INFO,
                recurrence=pattern,
                description="Test",
                text_template="Test",
            )
            empty_registry.register(f"test.type{i}", metadata, DummyGenerator)

        normal_types = empty_registry.get_by_recurrence(RecurrencePattern.NORMAL)
        assert len(normal_types) == 2

    def test_get_by_severity(self, empty_registry):
        """Should filter by severity."""
        severities = [LogSeverity.INFO, LogSeverity.ERROR, LogSeverity.INFO]
        for i, severity in enumerate(severities):
            metadata = LogTypeMetadata(
                name=f"test.type{i}",
                category="PLAYER",
                severity=severity,
                recurrence=RecurrencePattern.NORMAL,
                description="Test",
                text_template="Test",
            )
            empty_registry.register(f"test.type{i}", metadata, DummyGenerator)

        info_types = empty_registry.get_by_severity(LogSeverity.INFO)
        assert len(info_types) == 2

    def test_get_by_tag(self, empty_registry):
        """Should filter by tag."""
        tags_list = [("tag1",), ("tag2",), ("tag1", "tag2")]
        for i, tags in enumerate(tags_list):
            metadata = LogTypeMetadata(
                name=f"test.type{i}",
                category="PLAYER",
                severity=LogSeverity.INFO,
                recurrence=RecurrencePattern.NORMAL,
                description="Test",
                text_template="Test",
                tags=tags,
            )
            empty_registry.register(f"test.type{i}", metadata, DummyGenerator)

        tag1_types = empty_registry.get_by_tag("tag1")
        assert len(tag1_types) == 2

    def test_all_types(self, empty_registry):
        """Should return all registered types."""
        for i in range(3):
            metadata = LogTypeMetadata(
                name=f"test.type{i}",
                category="PLAYER",
                severity=LogSeverity.INFO,
                recurrence=RecurrencePattern.NORMAL,
                description="Test",
                text_template="Test",
            )
            empty_registry.register(f"test.type{i}", metadata, DummyGenerator)

        all_types = empty_registry.all_types()
        assert len(all_types) == 3

    def test_count(self, empty_registry):
        """Should return correct count."""
        assert empty_registry.count() == 0

        metadata = LogTypeMetadata(
            name="test.type",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test",
            text_template="Test",
        )
        empty_registry.register("test.type", metadata, DummyGenerator)
        assert empty_registry.count() == 1

    def test_is_registered(self, empty_registry):
        """Should check registration status."""
        assert not empty_registry.is_registered("test.type")

        metadata = LogTypeMetadata(
            name="test.type",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test",
            text_template="Test",
        )
        empty_registry.register("test.type", metadata, DummyGenerator)
        assert empty_registry.is_registered("test.type")

    def test_categories_summary(self, empty_registry):
        """Should return category summary."""
        categories = ["PLAYER", "SERVER", "PLAYER"]
        for i, cat in enumerate(categories):
            metadata = LogTypeMetadata(
                name=f"test.type{i}",
                category=cat,
                severity=LogSeverity.INFO,
                recurrence=RecurrencePattern.NORMAL,
                description="Test",
                text_template="Test",
            )
            empty_registry.register(f"test.type{i}", metadata, DummyGenerator)

        summary = empty_registry.categories_summary()
        assert summary["PLAYER"] == 2
        assert summary["SERVER"] == 1


class TestRegisterLogTypeDecorator:
    """Tests for register_log_type decorator."""

    def test_decorator_registers_type(self, reset_registry):
        """Decorator should register the type."""

        @register_log_type(
            name="decorated.test",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Decorated test",
            text_template="Test: {message}",
        )
        class DecoratedGenerator(BaseLogGenerator):
            def _generate_data(self, **kwargs):
                return {"message": "test"}

        registry = get_registry()
        assert registry.is_registered("decorated.test")

    def test_decorator_stores_metadata_on_class(self, reset_registry):
        """Decorator should store metadata on class."""

        @register_log_type(
            name="decorated.test",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Decorated test",
            text_template="Test: {message}",
        )
        class DecoratedGenerator(BaseLogGenerator):
            def _generate_data(self, **kwargs):
                return {"message": "test"}

        assert hasattr(DecoratedGenerator, "_log_type_metadata")
        assert DecoratedGenerator._log_type_metadata.name == "decorated.test"

    def test_decorator_with_optional_params(self, reset_registry):
        """Decorator should handle optional params."""

        @register_log_type(
            name="decorated.test",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Decorated test",
            text_template="Test: {message}",
            tags=["tag1", "tag2"],
        )
        class DecoratedGenerator(BaseLogGenerator):
            def _generate_data(self, **kwargs):
                return {"message": "test"}

        registry = get_registry()
        metadata = registry.get_metadata("decorated.test")
        assert "tag1" in metadata.tags


class TestGetRegistry:
    """Tests for get_registry function."""

    def test_returns_singleton(self, reset_registry):
        """Should return the singleton registry."""
        registry1 = get_registry()
        registry2 = get_registry()
        assert registry1 is registry2

    def test_returns_same_as_class(self, reset_registry):
        """Should return same instance as LogTypeRegistry()."""
        registry1 = get_registry()
        registry2 = LogTypeRegistry()
        assert registry1 is registry2


class TestPopulatedRegistry:
    """Tests with all generators registered."""

    def test_all_generators_registered(self, populated_registry):
        """Should have many generators registered."""
        count = populated_registry.count()
        # Should have 100+ log types
        assert count >= 100, f"Expected 100+ types, got {count}"

    def test_all_categories_have_types(self, populated_registry):
        """Each category should have registered types."""
        # Use dynamic categories from registry
        for category in populated_registry.get_categories():
            types = populated_registry.get_by_category(category.upper())
            assert len(types) > 0, f"Category {category} has no types"

    def test_player_types_exist(self, populated_registry):
        """Should have player types."""
        assert populated_registry.is_registered("player.login")
        assert populated_registry.is_registered("player.logout")

    def test_server_types_exist(self, populated_registry):
        """Should have server types."""
        assert populated_registry.is_registered("server.start")
        assert populated_registry.is_registered("server.stop")

    def test_security_types_exist(self, populated_registry):
        """Should have security types."""
        assert populated_registry.is_registered("security.login_failed")
        assert populated_registry.is_registered("admin.ban")

    def test_economy_types_exist(self, populated_registry):
        """Should have economy types."""
        assert populated_registry.is_registered("economy.gold_gain")
        assert populated_registry.is_registered("economy.trade_complete")

    def test_combat_types_exist(self, populated_registry):
        """Should have combat types."""
        assert populated_registry.is_registered("combat.damage_dealt")
        assert populated_registry.is_registered("combat.mob_kill")

    def test_technical_types_exist(self, populated_registry):
        """Should have technical types."""
        assert populated_registry.is_registered("technical.connection_open")
        assert populated_registry.is_registered("technical.error")
