"""
Tests for mmofakelog.generators.base module.

Tests the BaseLogGenerator abstract class.
"""

import pytest
from datetime import datetime
from typing import Any, Dict

from mmofakelog.generators.base import BaseLogGenerator
from mmofakelog.core.types import (
    LogEntry,
    LogSeverity,
    LogTypeMetadata,
    RecurrencePattern,
)


class ConcreteGenerator(BaseLogGenerator):
    """Concrete implementation for testing."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "message": kwargs.get("message", "test"),
            "value": kwargs.get("value", 100),
        }


class FailingGenerator(BaseLogGenerator):
    """Generator that raises exceptions."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        raise RuntimeError("Generation failed")


@pytest.fixture
def generator():
    """Create a test generator."""
    return ConcreteGenerator()


@pytest.fixture
def metadata():
    """Create test metadata."""
    return LogTypeMetadata(
        name="test.generator",
        category="PLAYER",
        severity=LogSeverity.INFO,
        recurrence=RecurrencePattern.NORMAL,
        description="Test generator",
        text_template="[{timestamp}] TEST: {message}",
    )


class TestBaseLogGenerator:
    """Tests for BaseLogGenerator."""

    def test_generate_returns_log_entry(self, generator, metadata):
        """Should return a LogEntry."""
        timestamp = datetime(2024, 1, 15, 12, 30, 45)

        entry = generator.generate(timestamp=timestamp, metadata=metadata)

        assert isinstance(entry, LogEntry)
        assert entry.log_type == "test.generator"
        assert entry.timestamp == timestamp
        assert entry.severity == LogSeverity.INFO
        assert entry.category == "PLAYER"

    def test_generate_includes_data(self, generator, metadata):
        """Should include generated data."""
        entry = generator.generate(
            timestamp=datetime.now(),
            metadata=metadata,
        )

        assert entry.data["message"] == "test"
        assert entry.data["value"] == 100

    def test_generate_passes_kwargs(self, generator, metadata):
        """Should pass kwargs to _generate_data."""
        entry = generator.generate(
            timestamp=datetime.now(),
            metadata=metadata,
            message="custom",
            value=42,
        )

        assert entry.data["message"] == "custom"
        assert entry.data["value"] == 42

    def test_generate_with_server_id(self, generator, metadata):
        """Should include server_id."""
        entry = generator.generate(
            timestamp=datetime.now(),
            metadata=metadata,
            server_id="test-server",
        )

        assert entry.server_id == "test-server"

    def test_generate_with_session_id(self, generator, metadata):
        """Should include session_id."""
        entry = generator.generate(
            timestamp=datetime.now(),
            metadata=metadata,
            session_id="sess-123",
        )

        assert entry.session_id == "sess-123"

    def test_generate_handles_exception(self, metadata):
        """Should handle exceptions gracefully."""
        generator = FailingGenerator()

        entry = generator.generate(
            timestamp=datetime.now(),
            metadata=metadata,
        )

        # Should return entry with error info
        assert "error" in entry.data
        assert "Generation failed" in entry.data["error"]

    def test_repr_without_metadata(self, generator):
        """Should have repr without metadata."""
        result = repr(generator)

        assert "ConcreteGenerator" in result

    def test_repr_with_metadata(self, generator, metadata):
        """Should show type name in repr when metadata set."""
        generator._log_type_metadata = metadata

        result = repr(generator)

        assert "ConcreteGenerator" in result
        assert "test.generator" in result


class TestBaseLogGeneratorAbstract:
    """Tests for abstract nature of BaseLogGenerator."""

    def test_cannot_instantiate_directly(self):
        """Should not be able to instantiate BaseLogGenerator directly."""
        with pytest.raises(TypeError):
            BaseLogGenerator()

    def test_must_implement_generate_data(self):
        """Subclass must implement _generate_data."""

        class IncompleteGenerator(BaseLogGenerator):
            pass

        with pytest.raises(TypeError):
            IncompleteGenerator()
