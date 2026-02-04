"""
Tests for mmofakelog.formatters.text_formatter module.

Tests the TextFormatter class.
"""

import pytest
from datetime import datetime

from agnolog.formatters.text_formatter import TextFormatter, ColorTextFormatter
from agnolog.core.registry import LogTypeRegistry
from agnolog.core.types import (
    LogEntry,
    LogSeverity,
    LogTypeMetadata,
    RecurrencePattern,
)
from agnolog.generators.base import BaseLogGenerator


class DummyGenerator(BaseLogGenerator):
    """Dummy generator for testing."""

    def _generate_data(self, **kwargs):
        return {}


@pytest.fixture
def text_formatter_registry(reset_registry):
    """Registry with test types for text formatting."""
    registry = LogTypeRegistry()

    metadata = LogTypeMetadata(
        name="test.formatted",
        category="PLAYER",
        severity=LogSeverity.INFO,
        recurrence=RecurrencePattern.NORMAL,
        description="Test type",
        text_template="[{timestamp}] TEST: user={username} level={level}",
    )
    registry.register("test.formatted", metadata, DummyGenerator)

    return registry


@pytest.fixture
def formatter(text_formatter_registry):
    """Default text formatter."""
    return TextFormatter(registry=text_formatter_registry)


class TestTextFormatterBasic:
    """Basic tests for TextFormatter."""

    def test_format_with_template(self, formatter):
        """Should format using log type template."""
        entry = LogEntry(
            log_type="test.formatted",
            timestamp=datetime(2024, 1, 15, 12, 30, 45),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"username": "TestPlayer", "level": 42},
        )

        result = formatter.format(entry)

        assert "2024-01-15 12:30:45" in result
        assert "TEST:" in result
        assert "TestPlayer" in result
        assert "42" in result

    def test_format_without_template(self, formatter):
        """Should use default format for unknown type."""
        entry = LogEntry(
            log_type="unknown.type",
            timestamp=datetime(2024, 1, 15, 12, 30, 45),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"key": "value"},
        )

        result = formatter.format(entry)

        assert "2024-01-15 12:30:45" in result
        assert "unknown.type" in result
        assert "key=value" in result

    def test_format_with_missing_template_keys(self, formatter):
        """Should handle missing template keys gracefully."""
        entry = LogEntry(
            log_type="test.formatted",
            timestamp=datetime(2024, 1, 15, 12, 30, 45),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={},  # Missing username and level
        )

        # Should not raise, should fall back to default format
        result = formatter.format(entry)
        assert "2024-01-15" in result


class TestTextFormatterOptions:
    """Tests for formatter options."""

    def test_custom_timestamp_format(self, text_formatter_registry):
        """Should use custom timestamp format."""
        formatter = TextFormatter(
            registry=text_formatter_registry,
            timestamp_format="%Y/%m/%d",
        )

        entry = LogEntry(
            log_type="test.formatted",
            timestamp=datetime(2024, 1, 15, 12, 30, 45),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"username": "Test", "level": 1},
        )

        result = formatter.format(entry)
        assert "2024/01/15" in result

    def test_include_severity(self, text_formatter_registry):
        """Should include severity when enabled."""
        formatter = TextFormatter(
            registry=text_formatter_registry,
            include_severity=True,
        )

        entry = LogEntry(
            log_type="unknown.type",
            timestamp=datetime(2024, 1, 15, 12, 30, 45),
            severity=LogSeverity.WARNING,
            category="PLAYER",
            data={},
        )

        result = formatter.format(entry)
        assert "WARNING" in result

    def test_include_category(self, text_formatter_registry):
        """Should include category when enabled."""
        formatter = TextFormatter(
            registry=text_formatter_registry,
            include_category=True,
        )

        entry = LogEntry(
            log_type="unknown.type",
            timestamp=datetime(2024, 1, 15, 12, 30, 45),
            severity=LogSeverity.INFO,
            category="COMBAT",
            data={},
        )

        result = formatter.format(entry)
        assert "COMBAT" in result


class TestTextFormatterDataValues:
    """Tests for data value formatting."""

    def test_format_boolean_true(self, formatter):
        """Should format True as 'yes'."""
        entry = LogEntry(
            log_type="unknown.type",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"active": True},
        )

        result = formatter.format(entry)
        assert "active=yes" in result

    def test_format_boolean_false(self, formatter):
        """Should format False as 'no'."""
        entry = LogEntry(
            log_type="unknown.type",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"active": False},
        )

        result = formatter.format(entry)
        assert "active=no" in result

    def test_format_float(self, formatter):
        """Should format float with 2 decimal places."""
        entry = LogEntry(
            log_type="unknown.type",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"value": 3.14159},
        )

        result = formatter.format(entry)
        assert "value=3.14" in result

    def test_format_list(self, formatter):
        """Should format list as comma-separated."""
        entry = LogEntry(
            log_type="unknown.type",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"items": ["a", "b", "c"]},
        )

        result = formatter.format(entry)
        assert "a, b, c" in result


class TestTextFormatterBatch:
    """Tests for batch formatting."""

    def test_format_batch(self, formatter, sample_log_entries):
        """Should format multiple entries with newlines."""
        result = formatter.format_batch(sample_log_entries)

        lines = result.split("\n")
        assert len(lines) == 5

    def test_format_batch_empty(self, formatter):
        """Should handle empty list."""
        result = formatter.format_batch([])
        assert result == ""


class TestColorTextFormatter:
    """Tests for ColorTextFormatter."""

    def test_color_enabled_by_default(self):
        """ColorTextFormatter should have color enabled."""
        formatter = ColorTextFormatter()
        assert formatter._color_enabled is True

    def test_color_codes_in_output(self, text_formatter_registry):
        """Should include ANSI color codes."""
        formatter = ColorTextFormatter(registry=text_formatter_registry)

        entry = LogEntry(
            log_type="test.formatted",
            timestamp=datetime.now(),
            severity=LogSeverity.ERROR,
            category="PLAYER",
            data={"username": "Test", "level": 1},
        )

        result = formatter.format(entry)

        # Should contain ANSI escape sequences
        assert "\033[" in result
        # Should contain reset code
        assert "\033[0m" in result


class TestTextFormatterColors:
    """Tests for color functionality."""

    def test_severity_colors_defined(self):
        """Should have colors for all severities."""
        expected = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]
        for sev in expected:
            assert sev in TextFormatter.SEVERITY_COLORS

    def test_no_color_by_default(self, formatter):
        """Should not include colors by default."""
        entry = LogEntry(
            log_type="unknown.type",
            timestamp=datetime.now(),
            severity=LogSeverity.ERROR,
            category="PLAYER",
            data={},
        )

        result = formatter.format(entry)

        # Should not contain ANSI escape sequences
        assert "\033[" not in result


class TestTextFormatterRepr:
    """Tests for repr."""

    def test_repr(self, formatter):
        """Should have meaningful repr."""
        result = repr(formatter)

        assert "TextFormatter" in result
        assert "timestamp_format" in result
