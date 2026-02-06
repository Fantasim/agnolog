"""
Tests for agnolog.formatters.csv_formatter module.

Tests the LoghubCSVFormatter class and template_to_loghub function.
"""

import csv
import io
from datetime import datetime

import pytest

from agnolog.core.constants import LOGHUB_CSV_COLUMNS, LOGHUB_TEMPLATE_COLUMNS
from agnolog.core.registry import LogTypeRegistry
from agnolog.core.types import (
    LogEntry,
    LogSeverity,
    LogTypeMetadata,
    RecurrencePattern,
)
from agnolog.formatters.csv_formatter import LoghubCSVFormatter, template_to_loghub
from agnolog.generators.base import BaseLogGenerator


class DummyGenerator(BaseLogGenerator):
    """Dummy generator for testing."""

    def _generate_data(self, **kwargs):
        return {}


@pytest.fixture
def csv_formatter_registry(reset_registry):
    """Registry with test types for CSV formatting."""
    registry = LogTypeRegistry()

    metadata1 = LogTypeMetadata(
        name="test.login",
        category="PLAYER",
        severity=LogSeverity.INFO,
        recurrence=RecurrencePattern.NORMAL,
        description="Test login",
        text_template="[{timestamp}] LOGIN: {username} from {ip}",
    )
    registry.register("test.login", metadata1, DummyGenerator)

    metadata2 = LogTypeMetadata(
        name="test.logout",
        category="PLAYER",
        severity=LogSeverity.INFO,
        recurrence=RecurrencePattern.NORMAL,
        description="Test logout",
        text_template="[{timestamp}] LOGOUT: {username}",
    )
    registry.register("test.logout", metadata2, DummyGenerator)

    metadata3 = LogTypeMetadata(
        name="test.error",
        category="SERVER",
        severity=LogSeverity.ERROR,
        recurrence=RecurrencePattern.RARE,
        description="Test error",
        text_template="[{timestamp}] ERROR: {message} (code={code})",
    )
    registry.register("test.error", metadata3, DummyGenerator)

    return registry


@pytest.fixture
def formatter(csv_formatter_registry):
    """Default CSV formatter."""
    return LoghubCSVFormatter(registry=csv_formatter_registry)


class TestTemplateToLoghub:
    """Tests for template_to_loghub function."""

    def test_single_placeholder(self):
        """Should convert single placeholder."""
        result = template_to_loghub("Hello {name}")
        assert result == "Hello <*>"

    def test_multiple_placeholders(self):
        """Should convert multiple placeholders."""
        result = template_to_loghub("{user} logged in from {ip}")
        assert result == "<*> logged in from <*>"

    def test_no_placeholders(self):
        """Should return unchanged if no placeholders."""
        result = template_to_loghub("Static message")
        assert result == "Static message"

    def test_complex_template(self):
        """Should handle complex templates."""
        result = template_to_loghub("[{timestamp}] LOGIN: {username} ({char_name}) from {ip}")
        assert result == "[<*>] LOGIN: <*> (<*>) from <*>"

    def test_placeholder_in_brackets(self):
        """Should handle placeholders inside other characters."""
        result = template_to_loghub("port {port} ssh2")
        assert result == "port <*> ssh2"


class TestLoghubCSVFormatterBasic:
    """Basic tests for LoghubCSVFormatter."""

    def test_format_header(self, formatter):
        """Should return correct CSV header."""
        header = formatter.format_header()

        # Parse as CSV to verify structure
        reader = csv.reader(io.StringIO(header))
        columns = next(reader)

        assert tuple(columns) == LOGHUB_CSV_COLUMNS

    def test_format_single_entry(self, formatter):
        """Should format a single entry correctly."""
        entry = LogEntry(
            log_type="test.login",
            timestamp=datetime(2024, 1, 15, 12, 30, 45),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"username": "TestPlayer", "ip": "192.168.1.100"},
        )

        result = formatter.format(entry)

        # Parse as CSV
        reader = csv.reader(io.StringIO(result))
        row = next(reader)

        # Check each column
        assert row[0] == "1"  # LineId
        assert row[1] == "Jan"  # Date (month)
        assert row[2] == "15"  # Day
        assert row[3] == "12:30:45"  # Time
        assert row[4] == "Server"  # Component
        # row[5] is Pid
        assert "TestPlayer" in row[6]  # Content contains username
        assert "192.168.1.100" in row[6]  # Content contains IP
        assert row[7].startswith("E")  # EventId
        assert "<*>" in row[8]  # EventTemplate has placeholder

    def test_line_id_increments(self, formatter):
        """Should increment line ID for each entry."""
        entry = LogEntry(
            log_type="test.login",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"username": "Test", "ip": "127.0.0.1"},
        )

        result1 = formatter.format(entry)
        result2 = formatter.format(entry)
        result3 = formatter.format(entry)

        reader = csv.reader(io.StringIO(result1))
        assert next(reader)[0] == "1"

        reader = csv.reader(io.StringIO(result2))
        assert next(reader)[0] == "2"

        reader = csv.reader(io.StringIO(result3))
        assert next(reader)[0] == "3"

    def test_reset_line_counter(self, formatter):
        """Should reset line counter."""
        entry = LogEntry(
            log_type="test.login",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"username": "Test", "ip": "127.0.0.1"},
        )

        formatter.format(entry)
        formatter.format(entry)
        formatter.reset_line_counter()
        result = formatter.format(entry)

        reader = csv.reader(io.StringIO(result))
        assert next(reader)[0] == "1"


class TestLoghubCSVFormatterOptions:
    """Tests for formatter options."""

    def test_custom_component(self, csv_formatter_registry):
        """Should use custom component name."""
        formatter = LoghubCSVFormatter(
            registry=csv_formatter_registry,
            component="GameServer01",
        )

        entry = LogEntry(
            log_type="test.login",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"username": "Test", "ip": "127.0.0.1"},
        )

        result = formatter.format(entry)
        reader = csv.reader(io.StringIO(result))
        row = next(reader)

        assert row[4] == "GameServer01"

    def test_pid_from_data(self, formatter):
        """Should use PID from log data when available."""
        entry = LogEntry(
            log_type="test.login",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category="PLAYER",
            data={"username": "Test", "ip": "127.0.0.1", "pid": 12345},
        )

        result = formatter.format(entry)
        reader = csv.reader(io.StringIO(result))
        row = next(reader)

        assert row[5] == "12345"


class TestLoghubCSVFormatterTemplates:
    """Tests for template-related functionality."""

    def test_get_templates(self, formatter):
        """Should return all templates."""
        templates = formatter.get_templates()

        assert len(templates) == 3  # We registered 3 types
        assert all(t[0].startswith("E") for t in templates)
        assert all("<*>" in t[1] for t in templates)

    def test_templates_sorted_by_event_id(self, formatter):
        """Should return templates sorted by EventId."""
        templates = formatter.get_templates()

        event_ids = [int(t[0][1:]) for t in templates]
        assert event_ids == sorted(event_ids)

    def test_format_templates_csv(self, formatter):
        """Should format complete templates CSV."""
        result = formatter.format_templates_csv()

        lines = result.split("\n")
        assert len(lines) == 4  # Header + 3 templates

        # Check header
        reader = csv.reader(io.StringIO(lines[0]))
        header = next(reader)
        assert tuple(header) == LOGHUB_TEMPLATE_COLUMNS

        # Check data rows have EventId and EventTemplate
        reader = csv.reader(io.StringIO(lines[1]))
        row = next(reader)
        assert row[0].startswith("E")
        assert len(row[1]) > 0


class TestLoghubCSVFormatterBatch:
    """Tests for batch formatting."""

    def test_format_batch(self, formatter, sample_log_entries):
        """Should format multiple entries without header."""
        result = formatter.format_batch(sample_log_entries)

        lines = result.split("\n")
        assert len(lines) == 5

        # Verify line IDs are sequential
        for i, line in enumerate(lines, start=1):
            reader = csv.reader(io.StringIO(line))
            row = next(reader)
            assert row[0] == str(i)

    def test_format_batch_with_header(self, formatter, sample_log_entries):
        """Should format with header when requested."""
        result = formatter.format_batch_with_header(sample_log_entries)

        lines = result.split("\n")
        assert len(lines) == 6  # Header + 5 entries

        # First line should be header
        reader = csv.reader(io.StringIO(lines[0]))
        header = next(reader)
        assert tuple(header) == LOGHUB_CSV_COLUMNS

    def test_format_batch_empty(self, formatter):
        """Should handle empty list."""
        result = formatter.format_batch([])
        assert result == ""


class TestLoghubCSVFormatterUnknownType:
    """Tests for handling unknown log types."""

    def test_unknown_log_type_uses_fallback(self, formatter):
        """Should use fallback for unknown log types."""
        entry = LogEntry(
            log_type="unknown.type",
            timestamp=datetime.now(),
            severity=LogSeverity.WARNING,
            category="OTHER",
            data={"key": "value"},
        )

        result = formatter.format(entry)
        reader = csv.reader(io.StringIO(result))
        row = next(reader)

        # Should have E0 as fallback EventId
        assert row[7] == "E0"


class TestLoghubCSVFormatterRepr:
    """Tests for repr."""

    def test_repr(self, formatter):
        """Should have meaningful repr."""
        result = repr(formatter)

        assert "LoghubCSVFormatter" in result
        assert "component" in result
        assert "templates" in result


class TestLoghubCSVFormatterMergeGroups:
    """Tests for merge group functionality."""

    def test_merge_group_included_in_templates(self, reset_registry):
        """Should include merge group in template output."""
        registry = LogTypeRegistry()

        metadata = LogTypeMetadata(
            name="test.grouped",
            category="TEST",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test grouped",
            text_template="[{timestamp}] GROUPED: {message}",
            merge_groups=("test_group",),
        )
        registry.register("test.grouped", metadata, DummyGenerator)

        formatter = LoghubCSVFormatter(registry=registry)
        templates = formatter.get_templates()

        assert len(templates) == 1
        assert templates[0][2] == "test_group"

    def test_multiple_merge_groups_comma_separated(self, reset_registry):
        """Should join multiple merge groups with commas."""
        registry = LogTypeRegistry()

        metadata = LogTypeMetadata(
            name="test.multi_group",
            category="TEST",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test multi group",
            text_template="[{timestamp}] MULTI: {message}",
            merge_groups=("group_a", "group_b"),
        )
        registry.register("test.multi_group", metadata, DummyGenerator)

        formatter = LoghubCSVFormatter(registry=registry)
        templates = formatter.get_templates()

        assert len(templates) == 1
        assert templates[0][2] == "group_a,group_b"

    def test_no_merge_group_returns_empty_string(self, formatter):
        """Should return empty string for templates without merge group."""
        templates = formatter.get_templates()

        # All test fixtures don't have merge_group
        for event_id, event_template, merge_groups in templates:
            assert merge_groups == ""

    def test_templates_csv_includes_merge_group_column(self, formatter):
        """Should include MergeGroups column in CSV output."""
        result = formatter.format_templates_csv()
        lines = result.split("\n")

        # Check header has 3 columns
        reader = csv.reader(io.StringIO(lines[0]))
        header = next(reader)
        assert tuple(header) == LOGHUB_TEMPLATE_COLUMNS
        assert "MergeGroups" in header

        # Check data rows have 3 columns
        reader = csv.reader(io.StringIO(lines[1]))
        row = next(reader)
        assert len(row) == 3

    def test_templates_csv_with_merge_groups(self, reset_registry):
        """Should output merge groups in templates CSV."""
        registry = LogTypeRegistry()

        metadata1 = LogTypeMetadata(
            name="test.login",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test login",
            text_template="[{timestamp}] LOGIN: {username}",
            merge_groups=("session_events", "auth_events"),
        )
        registry.register("test.login", metadata1, DummyGenerator)

        metadata2 = LogTypeMetadata(
            name="test.logout",
            category="PLAYER",
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test logout",
            text_template="[{timestamp}] LOGOUT: {username}",
            merge_groups=("session_events",),
        )
        registry.register("test.logout", metadata2, DummyGenerator)

        formatter = LoghubCSVFormatter(registry=registry)
        result = formatter.format_templates_csv()

        # Parse CSV
        reader = csv.DictReader(io.StringIO(result))
        rows = list(reader)

        assert len(rows) == 2

        # Find rows by EventTemplate content
        login_row = next(r for r in rows if "LOGIN" in r["EventTemplate"])
        logout_row = next(r for r in rows if "LOGOUT" in r["EventTemplate"])

        assert login_row["MergeGroups"] == "session_events,auth_events"
        assert logout_row["MergeGroups"] == "session_events"
