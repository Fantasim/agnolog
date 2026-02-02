"""
Internal logging for debugging the fake log generator itself.

This module provides logging infrastructure for the generator's
own operations, helping with debugging and monitoring.

NOT to be confused with the fake logs being generated.
"""

import logging
import sys
from typing import Optional

from mmofakelog.core.constants import (
    INTERNAL_LOG_DATE_FORMAT,
    INTERNAL_LOG_FORMAT,
    INTERNAL_LOG_LEVEL,
    INTERNAL_LOGGER_NAME,
)

# Module-level logger instance
_internal_logger: Optional[logging.Logger] = None


def setup_internal_logging(
    level: Optional[str] = None,
    log_file: Optional[str] = None,
    quiet: bool = False,
    format_string: Optional[str] = None,
) -> logging.Logger:
    """
    Setup internal logging for the generator.

    This should be called once at application startup to configure
    how internal debug/info messages are logged.

    Args:
        level: Log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
        log_file: Optional file to write logs to
        quiet: If True, suppress console output
        format_string: Custom format string (uses default if None)

    Returns:
        Configured logger instance
    """
    global _internal_logger

    logger = logging.getLogger(INTERNAL_LOGGER_NAME)

    # Set log level
    log_level = getattr(logging, (level or INTERNAL_LOG_LEVEL).upper(), logging.INFO)
    logger.setLevel(log_level)

    # Clear existing handlers to avoid duplicates
    logger.handlers.clear()

    # Create formatter
    formatter = logging.Formatter(
        format_string or INTERNAL_LOG_FORMAT,
        datefmt=INTERNAL_LOG_DATE_FORMAT,
    )

    # Console handler (stderr)
    if not quiet:
        console_handler = logging.StreamHandler(sys.stderr)
        console_handler.setFormatter(formatter)
        console_handler.setLevel(log_level)
        logger.addHandler(console_handler)

    # File handler
    if log_file:
        try:
            file_handler = logging.FileHandler(log_file, encoding="utf-8")
            file_handler.setFormatter(formatter)
            file_handler.setLevel(log_level)
            logger.addHandler(file_handler)
        except (OSError, IOError) as e:
            # Log to console if file logging fails
            if not quiet:
                logger.warning(f"Failed to setup file logging to {log_file}: {e}")

    # Prevent propagation to root logger
    logger.propagate = False

    _internal_logger = logger

    # Log initial setup message
    logger.debug(f"Internal logging configured: level={level or INTERNAL_LOG_LEVEL}, file={log_file}")

    return logger


def get_internal_logger() -> logging.Logger:
    """
    Get the internal logger instance.

    Creates a default logger if not already setup. This is safe
    to call from any module without prior initialization.

    Returns:
        The internal logger instance
    """
    global _internal_logger

    if _internal_logger is None:
        _internal_logger = setup_internal_logging(quiet=True)

    return _internal_logger


def reset_internal_logger() -> None:
    """
    Reset the internal logger (primarily for testing).

    This clears the global logger instance, allowing for
    fresh initialization.
    """
    global _internal_logger
    _internal_logger = None


class InternalLoggerMixin:
    """
    Mixin class that provides internal logging to other classes.

    Classes that inherit from this mixin get convenient logging
    methods that automatically include the class name.

    Usage:
        class MyGenerator(InternalLoggerMixin):
            def some_method(self):
                self._log_debug("Processing started")
                self._log_info("Generated 100 entries")
                self._log_warning("AI client not available, using fallback")
                self._log_error("Failed to generate entry")
    """

    @property
    def _logger(self) -> logging.Logger:
        """Get the internal logger instance."""
        if not hasattr(self, "_internal_logger_instance"):
            self._internal_logger_instance = get_internal_logger()
        return self._internal_logger_instance

    def _log_debug(self, message: str, *args: object, **kwargs: object) -> None:
        """Log a debug message with class context."""
        self._logger.debug(f"[{self.__class__.__name__}] {message}", *args, **kwargs)

    def _log_info(self, message: str, *args: object, **kwargs: object) -> None:
        """Log an info message with class context."""
        self._logger.info(f"[{self.__class__.__name__}] {message}", *args, **kwargs)

    def _log_warning(self, message: str, *args: object, **kwargs: object) -> None:
        """Log a warning message with class context."""
        self._logger.warning(f"[{self.__class__.__name__}] {message}", *args, **kwargs)

    def _log_error(self, message: str, *args: object, **kwargs: object) -> None:
        """Log an error message with class context."""
        self._logger.error(f"[{self.__class__.__name__}] {message}", *args, **kwargs)

    def _log_exception(self, message: str, *args: object, **kwargs: object) -> None:
        """Log an exception with traceback."""
        self._logger.exception(f"[{self.__class__.__name__}] {message}", *args, **kwargs)


class LogContext:
    """
    Context manager for scoped logging.

    Useful for tracking operation duration and status.

    Usage:
        logger = get_internal_logger()
        with LogContext(logger, "Generating batch"):
            # ... generate logs ...
        # Logs: "Generating batch started" and "Generating batch completed in X.XXs"
    """

    def __init__(
        self,
        logger: logging.Logger,
        operation: str,
        level: int = logging.INFO,
    ) -> None:
        """
        Initialize log context.

        Args:
            logger: Logger to use
            operation: Description of the operation
            level: Log level for messages
        """
        self.logger = logger
        self.operation = operation
        self.level = level
        self._start_time: float = 0

    def __enter__(self) -> "LogContext":
        """Log operation start."""
        import time

        self._start_time = time.time()
        self.logger.log(self.level, f"{self.operation} started")
        return self

    def __exit__(self, exc_type: object, exc_val: object, exc_tb: object) -> None:
        """Log operation completion or failure."""
        import time

        duration = time.time() - self._start_time

        if exc_type is not None:
            self.logger.error(
                f"{self.operation} failed after {duration:.3f}s: {exc_val}"
            )
        else:
            self.logger.log(
                self.level,
                f"{self.operation} completed in {duration:.3f}s",
            )
