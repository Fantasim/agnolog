"""
Tests for agnolog.core.types module.

Tests all enums, dataclasses, and protocols.
"""

from datetime import datetime

import pytest

from agnolog.core.types import (
    LogEntry,
    LogFormat,
    LogSeverity,
    LogTypeMetadata,
    RecurrencePattern,
)


class TestLogSeverity:
    """Tests for LogSeverity enum."""

    def test_all_severities_exist(self):
        expected = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]
        for sev in expected:
            assert hasattr(LogSeverity, sev)

    def test_severity_values_ordered(self):
        assert LogSeverity.DEBUG.value < LogSeverity.INFO.value
        assert LogSeverity.INFO.value < LogSeverity.WARNING.value
        assert LogSeverity.WARNING.value < LogSeverity.ERROR.value
        assert LogSeverity.ERROR.value < LogSeverity.CRITICAL.value


class TestLogFormat:
    """Tests for LogFormat enum."""

    def test_formats_exist(self):
        assert hasattr(LogFormat, "JSON")
        assert hasattr(LogFormat, "TEXT")


class TestRecurrencePattern:
    """Tests for RecurrencePattern enum."""

    def test_all_patterns_exist(self):
        expected = ["VERY_FREQUENT", "FREQUENT", "NORMAL", "INFREQUENT", "RARE"]
        for pattern in expected:
            assert hasattr(RecurrencePattern, pattern)


class TestLogTypeMetadata:
    """Tests for LogTypeMetadata dataclass."""

    def test_basic_creation(self):
        meta = LogTypeMetadata(
            name="player.login",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Player login event",
            text_template="[{timestamp}] LOGIN: {username}",
        )
        assert meta.name == "player.login"
        assert meta.category == "PLAYER"
        assert meta.tags == ()

    def test_with_optional_fields(self):
        meta = LogTypeMetadata(
            name="player.chat",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.FREQUENT,
            description="Player chat message",
            text_template="[{timestamp}] CHAT: {message}",
            tags=("chat", "social"),
        )
        assert "chat" in meta.tags

    def test_is_frozen(self):
        meta = LogTypeMetadata(
            name="test.type",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test",
            text_template="Test",
        )
        with pytest.raises(AttributeError):
            meta.name = "changed"

    def test_empty_name_raises(self):
        with pytest.raises(ValueError, match="cannot be empty"):
            LogTypeMetadata(
                name="",
                category="PLAYER",
                severity=LogSeverity.INFO,
                recurrence=RecurrencePattern.NORMAL,
                description="Test",
                text_template="Test",
            )

    def test_non_namespaced_name_raises(self):
        with pytest.raises(ValueError, match="namespaced"):
            LogTypeMetadata(
                name="invalid",
                category="PLAYER",
                severity=LogSeverity.INFO,
                recurrence=RecurrencePattern.NORMAL,
                description="Test",
                text_template="Test",
            )

    def test_custom_category(self):
        """Should support custom category strings."""
        meta = LogTypeMetadata(
            name="finance.transaction",
            category="FINANCE",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Financial transaction",
            text_template="[{timestamp}] TRANSACTION: {amount}",
        )
        assert meta.category == "FINANCE"

    def test_merge_groups_defaults_to_empty(self):
        """Should default merge_groups to empty tuple."""
        meta = LogTypeMetadata(
            name="test.type",
            category="TEST",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test",
            text_template="test",
        )
        assert meta.merge_groups == ()

    def test_merge_groups_can_be_set(self):
        """Should accept merge_groups value."""
        meta = LogTypeMetadata(
            name="test.type",
            category="TEST",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test",
            text_template="test",
            merge_groups=("session_events", "auth_events"),
        )
        assert meta.merge_groups == ("session_events", "auth_events")
        assert "session_events" in meta.merge_groups
        assert "auth_events" in meta.merge_groups


class TestLogEntry:
    """Tests for LogEntry dataclass."""

    def test_basic_creation(self):
        timestamp = datetime.now()
        entry = LogEntry(
            log_type="player.login",
            timestamp=timestamp,
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"username": "TestPlayer"},
        )
        assert entry.log_type == "player.login"
        assert entry.timestamp == timestamp
        assert entry.data["username"] == "TestPlayer"
        assert entry.server_id is None
        assert entry.session_id is None

    def test_with_optional_fields(self):
        entry = LogEntry(
            log_type="player.login",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={},
            server_id="server-01",
            session_id="sess-12345",
        )
        assert entry.server_id == "server-01"
        assert entry.session_id == "sess-12345"

    def test_to_dict(self):
        timestamp = datetime(2024, 1, 15, 12, 30, 45)
        entry = LogEntry(
            log_type="player.login",
            timestamp=timestamp,
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"username": "TestPlayer", "level": 42},
            server_id="server-01",
        )
        result = entry.to_dict()

        assert result["log_type"] == "player.login"
        assert result["timestamp"] == timestamp.isoformat()
        assert result["severity"] == "INFO"
        assert result["category"] == "PLAYER"
        assert result["username"] == "TestPlayer"
        assert result["level"] == 42
        assert result["server_id"] == "server-01"

    def test_to_dict_without_optional(self):
        entry = LogEntry(
            log_type="player.login",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={},
        )
        result = entry.to_dict()
        assert "server_id" not in result
        assert "session_id" not in result

    def test_custom_category(self):
        """Should support custom category strings."""
        entry = LogEntry(
            log_type="finance.transaction",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category="FINANCE",
            data={"amount": 100.50},
        )
        assert entry.category == "FINANCE"
        assert entry.to_dict()["category"] == "FINANCE"
