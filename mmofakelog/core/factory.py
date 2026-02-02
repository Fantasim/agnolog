"""
Log factory using the Factory pattern.

The factory creates log entries with proper dependency injection,
abstracting away the complexity of log generation.
"""

from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING, Any, Dict, List, Optional, Type

from mmofakelog.core.errors import GeneratorNotFoundError, LogTypeNotFoundError
from mmofakelog.core.registry import LogTypeRegistry, get_registry
from mmofakelog.core.types import LogCategory, LogEntry, LogTypeMetadata, RecurrencePattern

if TYPE_CHECKING:
    from mmofakelog.ai.client import AIClient
    from mmofakelog.generators.base import BaseLogGenerator


class LogFactory:
    """
    Factory for creating log entries.

    Uses the Factory pattern to abstract log creation and enable
    consistent log generation across all types. Dependencies
    (AI client, config) are injected for testability.

    Usage:
        factory = LogFactory(ai_client=my_ai_client)
        entry = factory.create("player.login")
        entries = factory.create_batch("player.login", count=10)
    """

    def __init__(
        self,
        registry: Optional[LogTypeRegistry] = None,
        ai_client: Optional[AIClient] = None,
        server_id: Optional[str] = None,
    ) -> None:
        """
        Initialize factory with dependencies.

        Args:
            registry: Log type registry (uses singleton if None)
            ai_client: Optional AI client for dynamic content
            server_id: Optional default server ID for entries
        """
        self._registry = registry or get_registry()
        self._ai_client = ai_client
        self._server_id = server_id
        self._generator_instances: Dict[str, BaseLogGenerator] = {}

        # Import internal logger lazily to avoid circular imports
        self._logger: Optional[Any] = None

    def _get_logger(self) -> Any:
        """Get internal logger, initializing if needed."""
        if self._logger is None:
            from mmofakelog.logging import get_internal_logger

            self._logger = get_internal_logger()
        return self._logger

    def _get_generator(self, log_type: str) -> Optional[BaseLogGenerator]:
        """
        Get or create a generator instance for a log type.

        Generator instances are cached for reuse.

        Args:
            log_type: The log type name

        Returns:
            Generator instance or None if not found
        """
        if log_type not in self._generator_instances:
            generator_class = self._registry.get_generator(log_type)
            if generator_class is None:
                self._get_logger().warning(f"Generator not found for log type: {log_type}")
                return None

            # Create generator with injected dependencies
            self._generator_instances[log_type] = generator_class(
                ai_client=self._ai_client,
            )
            self._get_logger().debug(f"Created generator instance for: {log_type}")

        return self._generator_instances[log_type]

    def create(
        self,
        log_type: str,
        timestamp: Optional[datetime] = None,
        session_id: Optional[str] = None,
        **kwargs: Any,
    ) -> Optional[LogEntry]:
        """
        Create a log entry of the specified type.

        Args:
            log_type: Registered log type name
            timestamp: Optional timestamp (uses now if None)
            session_id: Optional session identifier
            **kwargs: Additional parameters for the generator

        Returns:
            Generated LogEntry or None if type unknown
        """
        generator = self._get_generator(log_type)
        if generator is None:
            return None

        metadata = self._registry.get_metadata(log_type)
        if metadata is None:
            return None

        return generator.generate(
            timestamp=timestamp or datetime.now(),
            metadata=metadata,
            server_id=self._server_id,
            session_id=session_id,
            **kwargs,
        )

    def create_or_raise(
        self,
        log_type: str,
        timestamp: Optional[datetime] = None,
        session_id: Optional[str] = None,
        **kwargs: Any,
    ) -> LogEntry:
        """
        Create a log entry, raising if the type is not found.

        Args:
            log_type: Registered log type name
            timestamp: Optional timestamp (uses now if None)
            session_id: Optional session identifier
            **kwargs: Additional parameters for the generator

        Returns:
            Generated LogEntry

        Raises:
            LogTypeNotFoundError: If log type not registered
            GeneratorNotFoundError: If generator not found
        """
        metadata = self._registry.get_metadata(log_type)
        if metadata is None:
            raise LogTypeNotFoundError(
                log_type, available=self._registry.all_types()
            )

        generator = self._get_generator(log_type)
        if generator is None:
            raise GeneratorNotFoundError(log_type)

        return generator.generate(
            timestamp=timestamp or datetime.now(),
            metadata=metadata,
            server_id=self._server_id,
            session_id=session_id,
            **kwargs,
        )

    def create_batch(
        self,
        log_type: str,
        count: int,
        **kwargs: Any,
    ) -> List[LogEntry]:
        """
        Create multiple log entries of the same type.

        Args:
            log_type: Registered log type name
            count: Number of entries to create
            **kwargs: Additional parameters for the generator

        Returns:
            List of generated LogEntry objects
        """
        entries: List[LogEntry] = []
        for _ in range(count):
            entry = self.create(log_type, **kwargs)
            if entry is not None:
                entries.append(entry)
        return entries

    def create_random(
        self,
        category: Optional[LogCategory] = None,
        recurrence: Optional[RecurrencePattern] = None,
        timestamp: Optional[datetime] = None,
        **kwargs: Any,
    ) -> Optional[LogEntry]:
        """
        Create a random log entry, optionally filtered.

        Args:
            category: Optional category filter
            recurrence: Optional recurrence pattern filter
            timestamp: Optional timestamp
            **kwargs: Additional parameters for the generator

        Returns:
            Generated LogEntry or None if no types match
        """
        import random

        # Get available types
        types = self._registry.all_types()

        # Apply filters
        if category is not None:
            types = [t for t in types if self._registry.get_metadata(t).category == category]  # type: ignore

        if recurrence is not None:
            types = [t for t in types if self._registry.get_metadata(t).recurrence == recurrence]  # type: ignore

        if not types:
            return None

        log_type = random.choice(types)
        return self.create(log_type, timestamp=timestamp, **kwargs)

    def get_available_types(self) -> List[str]:
        """
        Get all available log types.

        Returns:
            List of registered log type names
        """
        return self._registry.all_types()

    def get_types_by_category(self, category: LogCategory) -> List[str]:
        """
        Get log types in a category.

        Args:
            category: Category to filter by

        Returns:
            List of log type names in the category
        """
        return self._registry.get_by_category(category)

    def set_ai_client(self, ai_client: AIClient) -> None:
        """
        Set or update the AI client.

        This will update all existing generator instances.

        Args:
            ai_client: The AI client to use
        """
        self._ai_client = ai_client
        # Update existing generators
        for generator in self._generator_instances.values():
            generator._ai_client = ai_client  # type: ignore

    def clear_cache(self) -> None:
        """Clear cached generator instances."""
        self._generator_instances.clear()
        self._get_logger().debug("Generator cache cleared")

    def get_metadata(self, log_type: str) -> Optional[LogTypeMetadata]:
        """
        Get metadata for a log type.

        Args:
            log_type: The log type name

        Returns:
            LogTypeMetadata or None if not found
        """
        return self._registry.get_metadata(log_type)

    @property
    def type_count(self) -> int:
        """Get the number of registered log types."""
        return self._registry.count()
