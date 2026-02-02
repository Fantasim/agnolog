"""
Tests for mmofakelog.core.errors module.

Ensures all exception types are properly defined and work correctly.
"""

import pytest
from mmofakelog.core.errors import (
    # Base
    MMOFakeLogError,
    # Configuration
    ConfigurationError,
    MissingConfigError,
    InvalidConfigValueError,
    ConfigFileError,
    # Registry
    RegistryError,
    LogTypeNotFoundError,
    DuplicateLogTypeError,
    InvalidLogTypeError,
    # Generator
    GeneratorError,
    DataGenerationError,
    MissingFieldError,
    GeneratorNotFoundError,
    # AI
    AIClientError,
    AIConnectionError,
    AIRateLimitError,
    AIResponseError,
    AIQuotaExceededError,
    AIConfigurationError,
    # Formatter
    FormatterError,
    TemplateError,
    UnsupportedFormatError,
    SerializationError,
    # Output
    OutputError,
    FileWriteError,
    FileReadError,
    PermissionDeniedError,
    DirectoryNotFoundError,
    # Scheduling
    SchedulingError,
    InvalidPatternError,
    TimeRangeError,
    SchedulerNotInitializedError,
    # Data
    DataError,
    DataNotFoundError,
    InvalidDataError,
    # Validation
    ValidationError,
)


class TestMMOFakeLogError:
    """Tests for base exception class."""

    def test_basic_initialization(self):
        error = MMOFakeLogError("Test error")
        assert error.message == "Test error"
        assert error.details == {}

    def test_with_details(self):
        error = MMOFakeLogError("Test error", {"key": "value"})
        assert error.details == {"key": "value"}

    def test_str_without_details(self):
        error = MMOFakeLogError("Test error")
        assert str(error) == "Test error"

    def test_str_with_details(self):
        error = MMOFakeLogError("Test error", {"key": "value"})
        assert "Test error" in str(error)
        assert "key='value'" in str(error)

    def test_repr(self):
        error = MMOFakeLogError("Test error", {"key": "value"})
        repr_str = repr(error)
        assert "MMOFakeLogError" in repr_str
        assert "Test error" in repr_str

    def test_is_exception(self):
        error = MMOFakeLogError("Test error")
        assert isinstance(error, Exception)


class TestConfigurationErrors:
    """Tests for configuration-related exceptions."""

    def test_configuration_error_inherits(self):
        error = ConfigurationError("Config error")
        assert isinstance(error, MMOFakeLogError)

    def test_missing_config_error(self):
        error = MissingConfigError("API_KEY")
        assert "API_KEY" in str(error)
        assert error.key == "API_KEY"

    def test_missing_config_error_with_hint(self):
        error = MissingConfigError("API_KEY", "Set OPENAI_API_KEY env var")
        assert "Set OPENAI_API_KEY" in str(error)
        assert error.hint == "Set OPENAI_API_KEY env var"

    def test_invalid_config_value_error(self):
        error = InvalidConfigValueError("timeout", -1, "positive integer")
        assert "timeout" in str(error)
        assert "-1" in str(error)
        assert "positive integer" in str(error)
        assert error.key == "timeout"
        assert error.value == -1

    def test_config_file_error(self):
        error = ConfigFileError("/path/to/config", "File not found")
        assert "/path/to/config" in str(error)
        assert "File not found" in str(error)
        assert error.path == "/path/to/config"


class TestRegistryErrors:
    """Tests for registry-related exceptions."""

    def test_registry_error_inherits(self):
        error = RegistryError("Registry error")
        assert isinstance(error, MMOFakeLogError)

    def test_log_type_not_found_error(self):
        error = LogTypeNotFoundError("player.invalid")
        assert "player.invalid" in str(error)
        assert error.log_type == "player.invalid"

    def test_log_type_not_found_with_available(self):
        available = ["player.login", "player.logout", "player.death"]
        error = LogTypeNotFoundError("player.invalid", available=available)
        assert "player.login" in str(error)
        assert error.available == available

    def test_duplicate_log_type_error(self):
        error = DuplicateLogTypeError("player.login")
        assert "player.login" in str(error)
        assert "already registered" in str(error)
        assert error.log_type == "player.login"

    def test_invalid_log_type_error(self):
        error = InvalidLogTypeError("invalid", "missing namespace")
        assert "invalid" in str(error)
        assert "missing namespace" in str(error)


class TestGeneratorErrors:
    """Tests for generator-related exceptions."""

    def test_generator_error_inherits(self):
        error = GeneratorError("Generator error")
        assert isinstance(error, MMOFakeLogError)

    def test_data_generation_error(self):
        error = DataGenerationError("player.login", "Random failure")
        assert "player.login" in str(error)
        assert "Random failure" in str(error)

    def test_data_generation_error_with_field(self):
        error = DataGenerationError("player.login", "Invalid value", field="username")
        assert "username" in str(error)
        assert error.field == "username"

    def test_missing_field_error(self):
        error = MissingFieldError("player.login", "username")
        assert "username" in str(error)
        assert "player.login" in str(error)

    def test_missing_field_error_with_available(self):
        error = MissingFieldError(
            "player.login", "username", available_fields=["id", "level"]
        )
        assert "id" in str(error)

    def test_generator_not_found_error(self):
        error = GeneratorNotFoundError("player.invalid")
        assert "player.invalid" in str(error)


class TestAIClientErrors:
    """Tests for AI client exceptions."""

    def test_ai_client_error_inherits(self):
        error = AIClientError("AI error")
        assert isinstance(error, MMOFakeLogError)

    def test_ai_connection_error(self):
        error = AIConnectionError("OpenAI", "Connection refused")
        assert "OpenAI" in str(error)
        assert "Connection refused" in str(error)
        assert error.service == "OpenAI"

    def test_ai_rate_limit_error(self):
        error = AIRateLimitError(retry_after=60)
        assert "rate limit" in str(error).lower()
        assert "60" in str(error)
        assert error.retry_after == 60

    def test_ai_rate_limit_error_with_type(self):
        error = AIRateLimitError(limit_type="tokens")
        assert "tokens" in str(error)
        assert error.limit_type == "tokens"

    def test_ai_response_error(self):
        error = AIResponseError("Empty response")
        assert "Empty response" in str(error)

    def test_ai_response_error_with_response(self):
        error = AIResponseError("Invalid format", response="bad data")
        assert error.response == "bad data"

    def test_ai_quota_exceeded_error(self):
        error = AIQuotaExceededError()
        assert "quota" in str(error).lower()

    def test_ai_configuration_error(self):
        error = AIConfigurationError("Missing API key")
        assert "Missing API key" in str(error)
        assert "OPENAI_API_KEY" in str(error)


class TestFormatterErrors:
    """Tests for formatter exceptions."""

    def test_formatter_error_inherits(self):
        error = FormatterError("Formatter error")
        assert isinstance(error, MMOFakeLogError)

    def test_template_error(self):
        error = TemplateError(
            "[{timestamp}] {missing}",
            missing_keys=["missing"],
        )
        assert "missing" in str(error)
        assert error.missing_keys == ["missing"]

    def test_template_error_with_available(self):
        error = TemplateError(
            "[{timestamp}] {missing}",
            missing_keys=["missing"],
            available_keys=["timestamp", "level"],
        )
        assert error.available_keys == ["timestamp", "level"]

    def test_unsupported_format_error(self):
        error = UnsupportedFormatError("xml")
        assert "xml" in str(error)

    def test_unsupported_format_error_with_supported(self):
        error = UnsupportedFormatError("xml", supported=["json", "text"])
        assert "json" in str(error)
        assert "text" in str(error)

    def test_serialization_error(self):
        error = SerializationError("player.login", "Circular reference")
        assert "player.login" in str(error)
        assert "Circular reference" in str(error)


class TestOutputErrors:
    """Tests for output exceptions."""

    def test_output_error_inherits(self):
        error = OutputError("Output error")
        assert isinstance(error, MMOFakeLogError)

    def test_file_write_error(self):
        error = FileWriteError("/path/to/file.log", "Disk full")
        assert "/path/to/file.log" in str(error)
        assert "Disk full" in str(error)
        assert error.path == "/path/to/file.log"

    def test_file_read_error(self):
        error = FileReadError("/path/to/file.log", "File not found")
        assert "/path/to/file.log" in str(error)
        assert "File not found" in str(error)

    def test_permission_denied_error(self):
        error = PermissionDeniedError("/path/to/file.log")
        assert "/path/to/file.log" in str(error)
        assert "Permission denied" in str(error)

    def test_permission_denied_error_with_operation(self):
        error = PermissionDeniedError("/path/to/file.log", operation="write")
        assert "write" in str(error)
        assert error.operation == "write"

    def test_directory_not_found_error(self):
        error = DirectoryNotFoundError("/path/to/dir")
        assert "/path/to/dir" in str(error)


class TestSchedulingErrors:
    """Tests for scheduling exceptions."""

    def test_scheduling_error_inherits(self):
        error = SchedulingError("Scheduling error")
        assert isinstance(error, MMOFakeLogError)

    def test_invalid_pattern_error(self):
        error = InvalidPatternError("INVALID")
        assert "INVALID" in str(error)

    def test_invalid_pattern_error_with_valid(self):
        error = InvalidPatternError("INVALID", valid_patterns=["NORMAL", "FREQUENT"])
        assert "NORMAL" in str(error)
        assert "FREQUENT" in str(error)

    def test_time_range_error(self):
        error = TimeRangeError("End time before start time")
        assert "End time before start time" in str(error)

    def test_scheduler_not_initialized_error(self):
        error = SchedulerNotInitializedError()
        assert "not initialized" in str(error).lower()


class TestDataErrors:
    """Tests for data exceptions."""

    def test_data_error_inherits(self):
        error = DataError("Data error")
        assert isinstance(error, MMOFakeLogError)

    def test_data_not_found_error(self):
        error = DataNotFoundError("Item", "sword_of_doom")
        assert "Item" in str(error)
        assert "sword_of_doom" in str(error)

    def test_invalid_data_error(self):
        error = InvalidDataError("Item", "Invalid rarity value")
        assert "Item" in str(error)
        assert "Invalid rarity value" in str(error)


class TestValidationError:
    """Tests for validation exception."""

    def test_validation_error_inherits(self):
        error = ValidationError("level", 100, "must be <= 60")
        assert isinstance(error, MMOFakeLogError)

    def test_validation_error_fields(self):
        error = ValidationError("level", 100, "must be <= 60")
        assert error.field == "level"
        assert error.value == 100
        assert error.constraint == "must be <= 60"

    def test_validation_error_str(self):
        error = ValidationError("level", 100, "must be <= 60")
        assert "level" in str(error)
        assert "must be <= 60" in str(error)


class TestErrorHierarchy:
    """Tests for exception inheritance hierarchy."""

    def test_all_errors_inherit_from_base(self):
        """All custom errors should inherit from MMOFakeLogError."""
        # Base error classes that take just a message
        error_classes = [
            ConfigurationError,
            RegistryError,
            GeneratorError,
            AIClientError,
            FormatterError,
            OutputError,
            SchedulingError,
            DataError,
        ]
        for cls in error_classes:
            error = cls("test")
            assert isinstance(error, MMOFakeLogError)

        # ValidationError has a different signature
        error = ValidationError("field", "value", "constraint")
        assert isinstance(error, MMOFakeLogError)

    def test_can_catch_all_with_base(self):
        """Should be able to catch all errors with MMOFakeLogError."""
        errors_to_test = [
            MissingConfigError("key"),
            LogTypeNotFoundError("type"),
            DataGenerationError("type", "reason"),
            AIConnectionError("service", "reason"),
            TemplateError("template", []),
            FileWriteError("path", "reason"),
            InvalidPatternError("pattern"),
            DataNotFoundError("type", "id"),
        ]
        for error in errors_to_test:
            try:
                raise error
            except MMOFakeLogError:
                pass  # Should catch
