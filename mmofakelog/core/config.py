"""
Configuration management for the MMORPG Fake Log Generator.

Handles loading configuration from environment variables,
files, and programmatic settings.
"""

import os
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Set

from mmofakelog.core.constants import (
    AI_CACHE_TTL,
    AI_MAX_TOKENS,
    AI_REQUEST_TIMEOUT,
    AI_TEMPERATURE,
    DEFAULT_AI_MODEL,
    DEFAULT_LOG_COUNT,
    DEFAULT_OUTPUT_FORMAT,
    DEFAULT_SERVER_ID,
    DEFAULT_TIME_SCALE,
    INTERNAL_LOG_LEVEL,
)
from mmofakelog.core.errors import InvalidConfigValueError, MissingConfigError
from mmofakelog.core.types import LogCategory, LogFormat


@dataclass
class AIConfig:
    """Configuration for AI/OpenAI integration."""

    enabled: bool = False
    api_key: Optional[str] = None
    model: str = DEFAULT_AI_MODEL
    max_tokens: int = AI_MAX_TOKENS
    temperature: float = AI_TEMPERATURE
    cache_enabled: bool = True
    cache_ttl: int = AI_CACHE_TTL
    timeout: int = AI_REQUEST_TIMEOUT

    def validate(self) -> None:
        """Validate AI configuration."""
        if self.enabled and not self.api_key:
            raise MissingConfigError(
                "OPENAI_API_KEY",
                hint="Set the OPENAI_API_KEY environment variable or disable AI",
            )
        if self.max_tokens < 1:
            raise InvalidConfigValueError(
                "max_tokens", self.max_tokens, "positive integer"
            )
        if not 0.0 <= self.temperature <= 2.0:
            raise InvalidConfigValueError(
                "temperature", self.temperature, "float between 0.0 and 2.0"
            )


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
    enabled_categories: Set[LogCategory] = field(
        default_factory=lambda: set(LogCategory)
    )
    enabled_types: Optional[Set[str]] = None  # None means all
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

    ai: AIConfig = field(default_factory=AIConfig)
    output: OutputConfig = field(default_factory=OutputConfig)
    generation: GenerationConfig = field(default_factory=GenerationConfig)
    logging: LoggingConfig = field(default_factory=LoggingConfig)

    @classmethod
    def from_env(cls) -> "Config":
        """
        Create configuration from environment variables.

        Environment variables:
            OPENAI_API_KEY: OpenAI API key
            OPENAI_MODEL: Model to use (default: gpt-3.5-turbo)
            LOG_LEVEL: Internal log level (DEBUG, INFO, WARNING, ERROR)
            LOG_FILE: Optional file for internal logs
            OUTPUT_FORMAT: json or text
            SERVER_ID: Default server identifier

        Returns:
            Config instance populated from environment
        """
        config = cls()

        # AI configuration
        api_key = os.environ.get("OPENAI_API_KEY")
        if api_key:
            config.ai.enabled = True
            config.ai.api_key = api_key
        config.ai.model = os.environ.get("OPENAI_MODEL", DEFAULT_AI_MODEL)

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
        self.ai.validate()

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
            "ai": {
                "enabled": self.ai.enabled,
                "model": self.ai.model,
                "max_tokens": self.ai.max_tokens,
                "temperature": self.ai.temperature,
                "cache_enabled": self.ai.cache_enabled,
            },
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
