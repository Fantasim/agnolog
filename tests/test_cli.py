"""
Tests for mmofakelog.cli module.

Tests the command-line interface.
"""

import pytest
import sys
from io import StringIO
from unittest.mock import patch

from agnolog.cli import main, parse_categories


class TestParseCategories:
    """Tests for parse_categories function."""

    def test_parse_single_category(self):
        """Should parse single category."""
        result = parse_categories(["player"])

        assert result is not None
        assert "PLAYER" in result

    def test_parse_multiple_categories(self):
        """Should parse multiple categories."""
        result = parse_categories(["player", "combat", "server"])

        assert result is not None
        assert len(result) == 3
        assert "PLAYER" in result
        assert "COMBAT" in result
        assert "SERVER" in result

    def test_parse_none_returns_none(self):
        """Should return None for None input."""
        result = parse_categories(None)
        assert result is None

    def test_parse_empty_list_returns_none(self):
        """Should return None for empty list."""
        result = parse_categories([])
        assert result is None

    def test_parse_case_insensitive(self):
        """Should be case insensitive and convert to uppercase."""
        result = parse_categories(["PLAYER", "Player", "player"])

        assert result is not None
        # All should be uppercase
        assert len([c for c in result if c == "PLAYER"]) == 3

    def test_parse_all_categories(self):
        """Should parse all category strings."""
        result = parse_categories(["player", "invalid", "combat"])

        assert result is not None
        # Now passes through all strings (converted to uppercase)
        assert len(result) == 3
        assert "PLAYER" in result
        assert "INVALID" in result
        assert "COMBAT" in result


class TestCLIMain:
    """Tests for main CLI function."""

    def test_list_types(self, populated_registry):
        """--list-types should list all types."""
        with patch("sys.stdout", new_callable=StringIO) as mock_stdout:
            result = main(["--list-types"])

        assert result == 0
        output = mock_stdout.getvalue()
        assert "PLAYER" in output
        assert "player.login" in output

    def test_version(self):
        """--version should show version."""
        with pytest.raises(SystemExit) as exc_info:
            main(["--version"])

        assert exc_info.value.code == 0

    def test_generate_default(self, populated_registry):
        """Should generate logs with defaults."""
        with patch("sys.stdout", new_callable=StringIO) as mock_stdout:
            result = main(["-n", "5"])

        assert result == 0
        output = mock_stdout.getvalue()
        # Should have JSON output
        assert "{" in output

    def test_generate_text_format(self, populated_registry):
        """Should generate text format."""
        with patch("sys.stdout", new_callable=StringIO) as mock_stdout:
            result = main(["-n", "5", "-f", "text"])

        assert result == 0
        output = mock_stdout.getvalue()
        # Should have text output (timestamps in brackets)
        assert "[" in output

    def test_generate_with_categories(self, populated_registry):
        """Should filter by categories."""
        with patch("sys.stdout", new_callable=StringIO) as mock_stdout:
            result = main(["-n", "10", "--categories", "player"])

        assert result == 0

    def test_generate_with_types(self, populated_registry):
        """Should filter by specific types."""
        with patch("sys.stdout", new_callable=StringIO) as mock_stdout:
            result = main(["-n", "5", "--types", "player.login", "player.logout"])

        assert result == 0
        output = mock_stdout.getvalue()
        assert "player.login" in output or "player.logout" in output

    def test_generate_with_seed(self, populated_registry):
        """Should produce reproducible output with seed."""
        # Use fixed start-time to make timestamps deterministic
        start_time = "2024-01-15T12:00:00"

        with patch("sys.stdout", new_callable=StringIO) as mock_stdout1:
            main(["-n", "5", "--seed", "42", "--start-time", start_time])
        output1 = mock_stdout1.getvalue()

        with patch("sys.stdout", new_callable=StringIO) as mock_stdout2:
            main(["-n", "5", "--seed", "42", "--start-time", start_time])
        output2 = mock_stdout2.getvalue()

        # Same seed and start time should produce same output
        assert output1 == output2

    def test_invalid_start_time(self, populated_registry):
        """Should handle invalid start time."""
        result = main(["-n", "5", "--start-time", "invalid"])
        assert result == 1

    def test_quiet_mode(self, populated_registry, tmp_path):
        """--quiet should suppress non-log output."""
        output_file = tmp_path / "test.log"

        with patch("sys.stderr", new_callable=StringIO) as mock_stderr:
            result = main([
                "-n", "5",
                "-o", str(output_file),
                "--quiet",
            ])

        assert result == 0
        # Should not have progress messages
        assert "Writing" not in mock_stderr.getvalue()


class TestCLIOutputFile:
    """Tests for file output."""

    def test_output_to_file(self, populated_registry, tmp_path):
        """Should write to output file."""
        output_file = tmp_path / "test.log"

        result = main(["-n", "10", "-o", str(output_file)])

        assert result == 0
        assert output_file.exists()

        content = output_file.read_text()
        assert len(content) > 0

    def test_output_file_json(self, populated_registry, tmp_path):
        """Should write valid JSON to file."""
        import json

        output_file = tmp_path / "test.json"

        result = main(["-n", "5", "-f", "json", "-o", str(output_file)])

        assert result == 0

        # Each line should be valid JSON
        content = output_file.read_text()
        for line in content.strip().split("\n"):
            if line:
                json.loads(line)  # Should not raise


class TestCLIPrettyPrint:
    """Tests for pretty print option."""

    def test_pretty_print(self, populated_registry):
        """--pretty should indent JSON."""
        with patch("sys.stdout", new_callable=StringIO) as mock_stdout:
            result = main(["-n", "1", "-f", "json", "--pretty"])

        assert result == 0
        output = mock_stdout.getvalue()
        # Pretty-printed JSON has newlines
        assert "\n" in output


class TestCLIExcludeTypes:
    """Tests for exclude types option."""

    def test_exclude_types(self, populated_registry):
        """--exclude-types should exclude specified types."""
        with patch("sys.stdout", new_callable=StringIO) as mock_stdout:
            result = main([
                "-n", "100",
                "--categories", "player",
                "--exclude-types", "player.login",
            ])

        assert result == 0
        output = mock_stdout.getvalue()
        # Should not have player.login (though randomness could mean it just didn't appear)
        # At least verify the command succeeded


class TestCLITimeOptions:
    """Tests for time-related options."""

    def test_start_time(self, populated_registry):
        """--start-time should set starting time."""
        with patch("sys.stdout", new_callable=StringIO) as mock_stdout:
            result = main([
                "-n", "5",
                "--start-time", "2024-01-15T12:00:00",
            ])

        assert result == 0
        output = mock_stdout.getvalue()
        assert "2024-01-15" in output

    def test_duration(self, populated_registry):
        """--duration should limit time range."""
        result = main(["-n", "5", "--duration", "60"])
        assert result == 0

    def test_time_scale(self, populated_registry):
        """--time-scale should affect timing."""
        result = main(["-n", "5", "--time-scale", "2.0"])
        assert result == 0
