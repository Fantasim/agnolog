"""
Configuration management for the Fake Log Generator.

Handles loading configuration from environment variables,
files, and programmatic settings.
"""

import os
from dataclasses import dataclass, field
from typing import Any, Dict, Optional, Set

from agnolog.core.constants import (
    DEFAULT_LOG_COUNT,
    DEFAULT_OUTPUT_FORMAT,
    DEFAULT_SERVER_ID,
    DEFAULT_TIME_SCALE,
    INTERNAL_LOG_LEVEL,
)
from agnolog.core.errors import InvalidConfigValueError
from agnolog.core.types import LogFormat


@dataclass
class OutputConfig:
    """Configuration for output handling."""

    format: LogFormat = LogFormat.JSON
    pretty_print: bool = False
    output_file: Optional[str] = None
    append_mode: bool = False
    include_metadata: bool = True
    include_server_id: bool = True
    include_session_id: bool = True


@dataclass
class GenerationConfig:
    """Configuration for log generation."""

    count: int = DEFAULT_LOG_COUNT
    time_scale: float = DEFAULT_TIME_SCALE
    server_id: str = DEFAULT_SERVER_ID
    enabled_categories: Optional[Set[str]] = None  # None means all categories
    enabled_types: Optional[Set[str]] = None  # None means all types
    disabled_types: Set[str] = field(default_factory=set)


@dataclass
class LoggingConfig:
    """Configuration for internal logging."""

    level: str = INTERNAL_LOG_LEVEL
    log_file: Optional[str] = None
    quiet: bool = False


@dataclass
class Config:
    """
    Main configuration container.

    Holds all configuration for the fake log generator.
    Can be loaded from environment variables or set programmatically.
    """

    output: OutputConfig = field(default_factory=OutputConfig)
    generation: GenerationConfig = field(default_factory=GenerationConfig)
    logging: LoggingConfig = field(default_factory=LoggingConfig)

    @classmethod
    def from_env(cls) -> "Config":
        """
        Create configuration from environment variables.

        Environment variables:
            LOG_LEVEL: Internal log level (DEBUG, INFO, WARNING, ERROR)
            LOG_FILE: Optional file for internal logs
            OUTPUT_FORMAT: json or text
            SERVER_ID: Default server identifier

        Returns:
            Config instance populated from environment
        """
        config = cls()

        # Logging configuration
        config.logging.level = os.environ.get("LOG_LEVEL", INTERNAL_LOG_LEVEL)
        config.logging.log_file = os.environ.get("LOG_FILE")

        # Output configuration
        output_format = os.environ.get("OUTPUT_FORMAT", DEFAULT_OUTPUT_FORMAT).upper()
        if output_format == "JSON":
            config.output.format = LogFormat.JSON
        elif output_format == "TEXT":
            config.output.format = LogFormat.TEXT

        # Generation configuration
        config.generation.server_id = os.environ.get("SERVER_ID", DEFAULT_SERVER_ID)

        return config

    def validate(self) -> None:
        """
        Validate the complete configuration.

        Raises:
            ConfigurationError: If any validation fails
        """
        if self.generation.count < 1:
            raise InvalidConfigValueError(
                "count", self.generation.count, "positive integer"
            )
        if self.generation.time_scale <= 0:
            raise InvalidConfigValueError(
                "time_scale", self.generation.time_scale, "positive float"
            )

    def to_dict(self) -> Dict[str, Any]:
        """Convert configuration to dictionary."""
        return {
            "output": {
                "format": self.output.format.name,
                "pretty_print": self.output.pretty_print,
                "output_file": self.output.output_file,
            },
            "generation": {
                "count": self.generation.count,
                "time_scale": self.generation.time_scale,
                "server_id": self.generation.server_id,
            },
            "logging": {
                "level": self.logging.level,
                "log_file": self.logging.log_file,
            },
        }


# Global configuration instance
_global_config: Optional[Config] = None


def get_config() -> Config:
    """
    Get the global configuration instance.

    Creates from environment if not already set.

    Returns:
        Global Config instance
    """
    global _global_config
    if _global_config is None:
        _global_config = Config.from_env()
    return _global_config


def set_config(config: Config) -> None:
    """
    Set the global configuration instance.

    Args:
        config: Config to use globally
    """
    global _global_config
    _global_config = config


def reset_config() -> None:
    """Reset global configuration to None."""
    global _global_config
    _global_config = None
