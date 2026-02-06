"""
Tests for agnolog.core.constants module.

Ensures all constants are properly defined and have valid values.
"""

from agnolog.core.constants import (
    DEFAULT_BATCH_SIZE,
    DEFAULT_LOG_COUNT,
    # Defaults
    DEFAULT_OUTPUT_FORMAT,
    DEFAULT_SERVER_ID,
    DEFAULT_TIME_SCALE,
    DEFAULT_TIMESTAMP_FORMAT,
    FILE_ENCODING,
    FILE_ROTATION_COUNT,
    FILE_ROTATION_SIZE,
    # Logging
    INTERNAL_LOG_FORMAT,
    INTERNAL_LOG_LEVEL,
    INTERNAL_LOGGER_NAME,
    JSON_INDENT,
    # Output
    MAX_LOG_LINE_LENGTH,
    PACKAGE_NAME,
    # Recurrence
    RECURRENCE_WEIGHTS,
    # Version
    VERSION,
)


class TestVersionConstants:
    """Tests for version-related constants."""

    def test_version_is_string(self):
        assert isinstance(VERSION, str)

    def test_version_format(self):
        # Version should be in semver format
        parts = VERSION.split(".")
        assert len(parts) >= 2
        assert all(p.isdigit() for p in parts[:2])

    def test_package_name(self):
        assert PACKAGE_NAME == "agnolog"


class TestDefaultConstants:
    """Tests for default configuration constants."""

    def test_default_output_format(self):
        assert DEFAULT_OUTPUT_FORMAT in ("json", "text", "ndjson")

    def test_default_log_count_positive(self):
        assert DEFAULT_LOG_COUNT > 0

    def test_default_batch_size_positive(self):
        assert DEFAULT_BATCH_SIZE > 0

    def test_default_server_id(self):
        assert isinstance(DEFAULT_SERVER_ID, str)
        assert len(DEFAULT_SERVER_ID) > 0

    def test_default_time_scale(self):
        assert DEFAULT_TIME_SCALE > 0


class TestRecurrenceWeights:
    """Tests for recurrence weight constants."""

    def test_all_patterns_have_weights(self):
        expected_patterns = [
            "VERY_FREQUENT",
            "FREQUENT",
            "NORMAL",
            "INFREQUENT",
            "RARE",
        ]
        for pattern in expected_patterns:
            assert pattern in RECURRENCE_WEIGHTS

    def test_weights_are_positive(self):
        for pattern, weight in RECURRENCE_WEIGHTS.items():
            assert weight > 0, f"{pattern} should have positive weight"

    def test_weights_order(self):
        # Very frequent should be higher than rare
        assert RECURRENCE_WEIGHTS["VERY_FREQUENT"] > RECURRENCE_WEIGHTS["RARE"]
        assert RECURRENCE_WEIGHTS["FREQUENT"] > RECURRENCE_WEIGHTS["NORMAL"]
        assert RECURRENCE_WEIGHTS["NORMAL"] > RECURRENCE_WEIGHTS["INFREQUENT"]


class TestOutputConstants:
    """Tests for output-related constants."""

    def test_max_line_length_reasonable(self):
        assert MAX_LOG_LINE_LENGTH >= 1024

    def test_timestamp_format_valid(self):
        from datetime import datetime

        # Should not raise an error
        datetime.now().strftime(DEFAULT_TIMESTAMP_FORMAT)

    def test_json_indent_positive(self):
        assert JSON_INDENT >= 0

    def test_file_rotation_size_reasonable(self):
        # At least 1MB
        assert FILE_ROTATION_SIZE >= 1024 * 1024

    def test_file_rotation_count_positive(self):
        assert FILE_ROTATION_COUNT > 0

    def test_file_encoding_valid(self):
        assert FILE_ENCODING == "utf-8"


class TestLoggingConstants:
    """Tests for internal logging constants."""

    def test_log_format_contains_placeholders(self):
        assert "%(asctime)s" in INTERNAL_LOG_FORMAT
        assert "%(levelname)s" in INTERNAL_LOG_FORMAT

    def test_log_level_valid(self):
        valid_levels = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]
        assert INTERNAL_LOG_LEVEL in valid_levels

    def test_logger_name_valid(self):
        assert isinstance(INTERNAL_LOGGER_NAME, str)
        assert len(INTERNAL_LOGGER_NAME) > 0
