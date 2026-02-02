"""
Tests for mmofakelog.formatters.json_formatter module.

Tests the JSONFormatter class.
"""

import json
import pytest
from datetime import datetime

from mmofakelog.formatters.json_formatter import JSONFormatter
from mmofakelog.core.types import LogCategory, LogEntry, LogSeverity


@pytest.fixture
def formatter():
    """Default JSON formatter."""
    return JSONFormatter()


@pytest.fixture
def pretty_formatter():
    """Pretty-printing JSON formatter."""
    return JSONFormatter(pretty=True)


class TestJSONFormatterBasic:
    """Basic tests for JSONFormatter."""

    def test_format_single_entry(self, formatter, sample_log_entry):
        """Should format a single entry as JSON."""
        result = formatter.format(sample_log_entry)

        # Should be valid JSON
        data = json.loads(result)
        assert data["type"] == "player.login"
        assert data["severity"] == "INFO"
        assert data["category"] == "PLAYER"
        assert data["username"] == "TestPlayer"

    def test_format_includes_timestamp(self, formatter, sample_log_entry):
        """Should include ISO timestamp."""
        result = formatter.format(sample_log_entry)
        data = json.loads(result)

        assert "timestamp" in data
        # Should be ISO format
        datetime.fromisoformat(data["timestamp"])

    def test_format_includes_metadata(self, formatter, sample_log_entry):
        """Should include server_id and session_id."""
        result = formatter.format(sample_log_entry)
        data = json.loads(result)

        assert data["server_id"] == "server-01"
        assert data["session_id"] == "sess-12345"

    def test_format_without_metadata(self, sample_log_entry):
        """Should exclude metadata when disabled."""
        formatter = JSONFormatter(include_metadata=False)
        sample_log_entry.server_id = "test"

        result = formatter.format(sample_log_entry)
        data = json.loads(result)

        # Metadata should not be in result
        assert "server_id" not in data


class TestJSONFormatterPretty:
    """Tests for pretty-printing."""

    def test_pretty_print_enabled(self, pretty_formatter, sample_log_entry):
        """Should indent when pretty=True."""
        result = pretty_formatter.format(sample_log_entry)

        # Pretty-printed JSON should have newlines
        assert "\n" in result
        assert "  " in result  # Indentation

    def test_not_pretty_by_default(self, formatter, sample_log_entry):
        """Should not indent by default."""
        result = formatter.format(sample_log_entry)

        # Should be single line
        assert "\n" not in result


class TestJSONFormatterBatch:
    """Tests for batch formatting."""

    def test_format_batch(self, formatter, sample_log_entries):
        """Should format multiple entries as JSON array."""
        result = formatter.format_batch(sample_log_entries)

        # Should be valid JSON array
        data = json.loads(result)
        assert isinstance(data, list)
        assert len(data) == 5

    def test_format_batch_empty(self, formatter):
        """Should handle empty list."""
        result = formatter.format_batch([])

        data = json.loads(result)
        assert data == []


class TestJSONFormatterNDJSON:
    """Tests for NDJSON formatting."""

    def test_format_ndjson(self, formatter, sample_log_entries):
        """Should format as newline-delimited JSON."""
        result = formatter.format_ndjson(sample_log_entries)

        # Should have one JSON object per line
        lines = result.strip().split("\n")
        assert len(lines) == 5

        # Each line should be valid JSON
        for line in lines:
            data = json.loads(line)
            assert "type" in data

    def test_format_ndjson_not_pretty(self, pretty_formatter, sample_log_entries):
        """NDJSON should not be pretty-printed."""
        result = pretty_formatter.format_ndjson(sample_log_entries)

        # Each line should be single-line JSON
        lines = result.strip().split("\n")
        for line in lines:
            # Line should not have indentation
            assert not line.startswith(" ")


class TestJSONFormatterSerialization:
    """Tests for value serialization."""

    def test_serialize_datetime(self, formatter, sample_timestamp):
        """Should serialize datetime to ISO format."""
        entry = LogEntry(
            log_type="test.type",
            timestamp=sample_timestamp,
            severity=LogSeverity.INFO,
            category=LogCategory.PLAYER,
            data={"event_time": sample_timestamp},
        )

        result = formatter.format(entry)
        data = json.loads(result)

        # Should be ISO format
        assert data["timestamp"] == "2024-01-15T12:30:45.123456"

    def test_serialize_enum(self, formatter, sample_timestamp):
        """Should serialize enums to their name."""
        entry = LogEntry(
            log_type="test.type",
            timestamp=sample_timestamp,
            severity=LogSeverity.INFO,
            category=LogCategory.PLAYER,
            data={"severity_ref": LogSeverity.ERROR},
        )

        result = formatter.format(entry)
        data = json.loads(result)

        assert data["severity_ref"] == "ERROR"

    def test_serialize_nested_dict(self, formatter, sample_timestamp):
        """Should serialize nested dictionaries."""
        entry = LogEntry(
            log_type="test.type",
            timestamp=sample_timestamp,
            severity=LogSeverity.INFO,
            category=LogCategory.PLAYER,
            data={"nested": {"key": "value", "number": 42}},
        )

        result = formatter.format(entry)
        data = json.loads(result)

        assert data["nested"]["key"] == "value"
        assert data["nested"]["number"] == 42

    def test_serialize_list(self, formatter, sample_timestamp):
        """Should serialize lists."""
        entry = LogEntry(
            log_type="test.type",
            timestamp=sample_timestamp,
            severity=LogSeverity.INFO,
            category=LogCategory.PLAYER,
            data={"items": ["a", "b", "c"]},
        )

        result = formatter.format(entry)
        data = json.loads(result)

        assert data["items"] == ["a", "b", "c"]

    def test_custom_date_format(self, sample_log_entry):
        """Should use custom date format when specified."""
        formatter = JSONFormatter(date_format="%Y-%m-%d")

        result = formatter.format(sample_log_entry)
        data = json.loads(result)

        assert data["timestamp"] == "2024-01-15"


class TestJSONFormatterOptions:
    """Tests for formatter options."""

    def test_sort_keys(self, sample_log_entry):
        """Should sort keys when enabled."""
        formatter = JSONFormatter(sort_keys=True)

        result = formatter.format(sample_log_entry)
        data = json.loads(result)

        # Keys should be sorted
        keys = list(data.keys())
        assert keys == sorted(keys)

    def test_ensure_ascii(self, sample_timestamp):
        """Should escape non-ASCII when enabled."""
        entry = LogEntry(
            log_type="test.type",
            timestamp=sample_timestamp,
            severity=LogSeverity.INFO,
            category=LogCategory.PLAYER,
            data={"message": "Hello \u4e16\u754c"},  # "Hello World" in Chinese
        )

        formatter_ascii = JSONFormatter(ensure_ascii=True)
        result = formatter_ascii.format(entry)

        # Should have escaped unicode
        assert "\\u" in result

        formatter_utf8 = JSONFormatter(ensure_ascii=False)
        result = formatter_utf8.format(entry)

        # Should have actual unicode characters
        assert "\u4e16\u754c" in result

    def test_repr(self, formatter, pretty_formatter):
        """Should have meaningful repr."""
        assert "JSONFormatter" in repr(formatter)
        assert "pretty=False" in repr(formatter)
        assert "pretty=True" in repr(pretty_formatter)
