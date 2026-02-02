"""
All error types for the MMORPG Fake Log Generator.

This file contains ALL custom exceptions used throughout
the application, organized by category. Each exception
includes helpful context for debugging.
"""

from typing import Any, Dict, List, Optional


# =============================================================================
# BASE EXCEPTION
# =============================================================================


class MMOFakeLogError(Exception):
    """
    Base exception for all mmofakelog errors.

    All custom exceptions in this package inherit from this class,
    allowing users to catch all package-specific errors with a single
    except clause if desired.

    Attributes:
        message: Human-readable error description
        details: Additional context as a dictionary
    """

    def __init__(self, message: str, details: Optional[Dict[str, Any]] = None) -> None:
        super().__init__(message)
        self.message = message
        self.details = details or {}

    def __str__(self) -> str:
        if self.details:
            detail_str = ", ".join(f"{k}={v!r}" for k, v in self.details.items())
            return f"{self.message} ({detail_str})"
        return self.message

    def __repr__(self) -> str:
        return f"{self.__class__.__name__}({self.message!r}, details={self.details!r})"


# =============================================================================
# CONFIGURATION ERRORS
# =============================================================================


class ConfigurationError(MMOFakeLogError):
    """Raised when configuration is invalid or incomplete."""

    pass


class MissingConfigError(ConfigurationError):
    """Raised when a required configuration value is missing."""

    def __init__(self, key: str, hint: Optional[str] = None) -> None:
        message = f"Missing required configuration: {key}"
        if hint:
            message += f". {hint}"
        super().__init__(message, details={"key": key})
        self.key = key
        self.hint = hint


class InvalidConfigValueError(ConfigurationError):
    """Raised when a configuration value is invalid."""

    def __init__(
        self,
        key: str,
        value: Any,
        expected: str,
        hint: Optional[str] = None,
    ) -> None:
        message = f"Invalid value for '{key}': {value!r}. Expected: {expected}"
        if hint:
            message += f". {hint}"
        super().__init__(
            message,
            details={"key": key, "value": value, "expected": expected},
        )
        self.key = key
        self.value = value
        self.expected = expected


class ConfigFileError(ConfigurationError):
    """Raised when configuration file cannot be read or parsed."""

    def __init__(self, path: str, reason: str) -> None:
        super().__init__(
            f"Failed to load configuration from {path}: {reason}",
            details={"path": path, "reason": reason},
        )
        self.path = path
        self.reason = reason


# =============================================================================
# REGISTRY ERRORS
# =============================================================================


class RegistryError(MMOFakeLogError):
    """Base error for log type registry operations."""

    pass


class LogTypeNotFoundError(RegistryError):
    """Raised when requesting an unregistered log type."""

    def __init__(self, log_type: str, available: Optional[List[str]] = None) -> None:
        message = f"Log type not found: {log_type}"
        details: Dict[str, Any] = {"log_type": log_type}
        if available:
            message += f". Available types: {', '.join(available[:5])}"
            if len(available) > 5:
                message += f" and {len(available) - 5} more"
            details["available_count"] = len(available)
        super().__init__(message, details=details)
        self.log_type = log_type
        self.available = available


class DuplicateLogTypeError(RegistryError):
    """Raised when attempting to register a log type that already exists."""

    def __init__(self, log_type: str) -> None:
        super().__init__(
            f"Log type already registered: {log_type}. "
            "Use a unique name or unregister the existing type first.",
            details={"log_type": log_type},
        )
        self.log_type = log_type


class InvalidLogTypeError(RegistryError):
    """Raised when log type name is invalid."""

    def __init__(self, log_type: str, reason: str) -> None:
        super().__init__(
            f"Invalid log type name '{log_type}': {reason}",
            details={"log_type": log_type, "reason": reason},
        )
        self.log_type = log_type
        self.reason = reason


# =============================================================================
# GENERATOR ERRORS
# =============================================================================


class GeneratorError(MMOFakeLogError):
    """Base error for log generation operations."""

    pass


class DataGenerationError(GeneratorError):
    """Raised when data generation fails for a log type."""

    def __init__(self, log_type: str, reason: str, field: Optional[str] = None) -> None:
        message = f"Failed to generate data for '{log_type}': {reason}"
        details: Dict[str, Any] = {"log_type": log_type, "reason": reason}
        if field:
            message = f"Failed to generate field '{field}' for '{log_type}': {reason}"
            details["field"] = field
        super().__init__(message, details=details)
        self.log_type = log_type
        self.reason = reason
        self.field = field


class MissingFieldError(GeneratorError):
    """Raised when a required field is missing from generated data."""

    def __init__(
        self,
        log_type: str,
        field: str,
        available_fields: Optional[List[str]] = None,
    ) -> None:
        message = f"Missing required field '{field}' in log type '{log_type}'"
        details: Dict[str, Any] = {"log_type": log_type, "field": field}
        if available_fields:
            message += f". Available fields: {', '.join(available_fields)}"
            details["available_fields"] = available_fields
        super().__init__(message, details=details)
        self.log_type = log_type
        self.field = field
        self.available_fields = available_fields


class GeneratorNotFoundError(GeneratorError):
    """Raised when no generator is registered for a log type."""

    def __init__(self, log_type: str) -> None:
        super().__init__(
            f"No generator found for log type: {log_type}",
            details={"log_type": log_type},
        )
        self.log_type = log_type


# =============================================================================
# AI CLIENT ERRORS
# =============================================================================


class AIClientError(MMOFakeLogError):
    """Base error for AI/OpenAI operations."""

    pass


class AIConnectionError(AIClientError):
    """Raised when connection to AI service fails."""

    def __init__(self, service: str, reason: str) -> None:
        super().__init__(
            f"Failed to connect to {service}: {reason}",
            details={"service": service, "reason": reason},
        )
        self.service = service
        self.reason = reason


class AIRateLimitError(AIClientError):
    """Raised when AI API rate limit is exceeded."""

    def __init__(
        self,
        retry_after: Optional[int] = None,
        limit_type: str = "requests",
    ) -> None:
        message = f"AI rate limit exceeded ({limit_type})"
        details: Dict[str, Any] = {"limit_type": limit_type}
        if retry_after is not None:
            message += f". Retry after {retry_after} seconds"
            details["retry_after"] = retry_after
        super().__init__(message, details=details)
        self.retry_after = retry_after
        self.limit_type = limit_type


class AIResponseError(AIClientError):
    """Raised when AI response is invalid or unexpected."""

    def __init__(
        self,
        reason: str,
        response: Optional[str] = None,
    ) -> None:
        message = f"Invalid AI response: {reason}"
        details: Dict[str, Any] = {"reason": reason}
        if response:
            # Truncate long responses
            truncated = response[:200] + "..." if len(response) > 200 else response
            details["response_preview"] = truncated
        super().__init__(message, details=details)
        self.reason = reason
        self.response = response


class AIQuotaExceededError(AIClientError):
    """Raised when AI API quota is exceeded."""

    def __init__(self, quota_type: str = "monthly") -> None:
        super().__init__(
            f"AI API {quota_type} quota exceeded. "
            "Check your billing settings or wait for quota reset.",
            details={"quota_type": quota_type},
        )
        self.quota_type = quota_type


class AIConfigurationError(AIClientError):
    """Raised when AI client is not properly configured."""

    def __init__(self, reason: str) -> None:
        super().__init__(
            f"AI client configuration error: {reason}. "
            "Ensure OPENAI_API_KEY environment variable is set.",
            details={"reason": reason},
        )
        self.reason = reason


# =============================================================================
# FORMATTER ERRORS
# =============================================================================


class FormatterError(MMOFakeLogError):
    """Base error for log formatting operations."""

    pass


class TemplateError(FormatterError):
    """Raised when template formatting fails."""

    def __init__(
        self,
        template: str,
        missing_keys: List[str],
        available_keys: Optional[List[str]] = None,
    ) -> None:
        message = f"Template formatting failed. Missing keys: {', '.join(missing_keys)}"
        details: Dict[str, Any] = {
            "template": template[:100] + "..." if len(template) > 100 else template,
            "missing_keys": missing_keys,
        }
        if available_keys:
            details["available_keys"] = available_keys
        super().__init__(message, details=details)
        self.template = template
        self.missing_keys = missing_keys
        self.available_keys = available_keys


class UnsupportedFormatError(FormatterError):
    """Raised when output format is not supported."""

    def __init__(self, format_name: str, supported: Optional[List[str]] = None) -> None:
        message = f"Unsupported output format: {format_name}"
        details: Dict[str, Any] = {"format": format_name}
        if supported:
            message += f". Supported formats: {', '.join(supported)}"
            details["supported"] = supported
        super().__init__(message, details=details)
        self.format_name = format_name
        self.supported = supported


class SerializationError(FormatterError):
    """Raised when log entry cannot be serialized."""

    def __init__(self, log_type: str, reason: str) -> None:
        super().__init__(
            f"Failed to serialize log entry of type '{log_type}': {reason}",
            details={"log_type": log_type, "reason": reason},
        )
        self.log_type = log_type
        self.reason = reason


# =============================================================================
# OUTPUT ERRORS
# =============================================================================


class OutputError(MMOFakeLogError):
    """Base error for output operations."""

    pass


class FileWriteError(OutputError):
    """Raised when writing to file fails."""

    def __init__(self, path: str, reason: str) -> None:
        super().__init__(
            f"Failed to write to file '{path}': {reason}",
            details={"path": path, "reason": reason},
        )
        self.path = path
        self.reason = reason


class FileReadError(OutputError):
    """Raised when reading from file fails."""

    def __init__(self, path: str, reason: str) -> None:
        super().__init__(
            f"Failed to read from file '{path}': {reason}",
            details={"path": path, "reason": reason},
        )
        self.path = path
        self.reason = reason


class PermissionDeniedError(OutputError):
    """Raised when file/directory access is denied."""

    def __init__(self, path: str, operation: str = "access") -> None:
        super().__init__(
            f"Permission denied: cannot {operation} '{path}'",
            details={"path": path, "operation": operation},
        )
        self.path = path
        self.operation = operation


class DirectoryNotFoundError(OutputError):
    """Raised when output directory does not exist."""

    def __init__(self, path: str) -> None:
        super().__init__(
            f"Directory not found: {path}",
            details={"path": path},
        )
        self.path = path


# =============================================================================
# SCHEDULING ERRORS
# =============================================================================


class SchedulingError(MMOFakeLogError):
    """Base error for scheduling operations."""

    pass


class InvalidPatternError(SchedulingError):
    """Raised when recurrence pattern is invalid."""

    def __init__(self, pattern: str, valid_patterns: Optional[List[str]] = None) -> None:
        message = f"Invalid recurrence pattern: {pattern}"
        details: Dict[str, Any] = {"pattern": pattern}
        if valid_patterns:
            message += f". Valid patterns: {', '.join(valid_patterns)}"
            details["valid_patterns"] = valid_patterns
        super().__init__(message, details=details)
        self.pattern = pattern
        self.valid_patterns = valid_patterns


class TimeRangeError(SchedulingError):
    """Raised when time range is invalid."""

    def __init__(self, reason: str) -> None:
        super().__init__(
            f"Invalid time range: {reason}",
            details={"reason": reason},
        )
        self.reason = reason


class SchedulerNotInitializedError(SchedulingError):
    """Raised when scheduler is used before initialization."""

    def __init__(self) -> None:
        super().__init__(
            "Scheduler not initialized. Call initialize() before generating logs.",
        )


# =============================================================================
# DATA ERRORS
# =============================================================================


class DataError(MMOFakeLogError):
    """Base error for game data operations."""

    pass


class DataNotFoundError(DataError):
    """Raised when requested game data is not found."""

    def __init__(self, data_type: str, identifier: str) -> None:
        super().__init__(
            f"{data_type} not found: {identifier}",
            details={"data_type": data_type, "identifier": identifier},
        )
        self.data_type = data_type
        self.identifier = identifier


class InvalidDataError(DataError):
    """Raised when game data is invalid or corrupted."""

    def __init__(self, data_type: str, reason: str) -> None:
        super().__init__(
            f"Invalid {data_type}: {reason}",
            details={"data_type": data_type, "reason": reason},
        )
        self.data_type = data_type
        self.reason = reason


# =============================================================================
# VALIDATION ERRORS
# =============================================================================


class ValidationError(MMOFakeLogError):
    """Raised when input validation fails."""

    def __init__(
        self,
        field: str,
        value: Any,
        constraint: str,
    ) -> None:
        super().__init__(
            f"Validation failed for '{field}': {constraint}",
            details={"field": field, "value": value, "constraint": constraint},
        )
        self.field = field
        self.value = value
        self.constraint = constraint
