"""
Log type registry using the Registry pattern.

The registry allows log types to self-register via decorator,
making it easy to add new log types without modifying core code.
This promotes extensibility and maintainability.
"""

from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING, Callable, Dict, List, Optional, Type, Union

from mmofakelog.core.errors import DuplicateLogTypeError, InvalidLogTypeError, LogTypeNotFoundError
from mmofakelog.core.types import LogCategory, LogSeverity, LogTypeMetadata, RecurrencePattern

if TYPE_CHECKING:
    from mmofakelog.generators.base import BaseLogGenerator


class LogTypeRegistry:
    """
    Central registry for all log types.

    Uses the Singleton pattern to ensure a single global registry.
    Log types register themselves via the @register_log_type decorator.

    Usage:
        registry = LogTypeRegistry()
        for log_type in registry.all_types():
            print(log_type)
    """

    _instance: Optional[LogTypeRegistry] = None

    def __new__(cls) -> LogTypeRegistry:
        """Ensure singleton instance."""
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._registry: Dict[str, LogTypeMetadata] = {}
            cls._instance._generators: Dict[str, Type[BaseLogGenerator]] = {}
            cls._instance._initialized = True
        return cls._instance

    @classmethod
    def reset(cls) -> None:
        """
        Reset the registry (primarily for testing).

        This clears all registered types and allows for fresh registration.
        """
        cls._instance = None

    def register(
        self,
        name: str,
        metadata: LogTypeMetadata,
        generator_class: Type[BaseLogGenerator],
    ) -> None:
        """
        Register a new log type.

        Args:
            name: Unique log type identifier
            metadata: Log type metadata
            generator_class: The generator class for this log type

        Raises:
            DuplicateLogTypeError: If log type already registered
            InvalidLogTypeError: If log type name is invalid
        """
        # Validate name
        if not name:
            raise InvalidLogTypeError(name, "Name cannot be empty")
        if not isinstance(name, str):
            raise InvalidLogTypeError(str(name), "Name must be a string")
        if "." not in name:
            raise InvalidLogTypeError(
                name, "Name must be namespaced (e.g., 'player.login')"
            )

        # Check for duplicates
        if name in self._registry:
            raise DuplicateLogTypeError(name)

        self._registry[name] = metadata
        self._generators[name] = generator_class

    def unregister(self, name: str) -> bool:
        """
        Unregister a log type.

        Args:
            name: Log type to unregister

        Returns:
            True if unregistered, False if not found
        """
        if name in self._registry:
            del self._registry[name]
            del self._generators[name]
            return True
        return False

    def get_metadata(self, name: str) -> Optional[LogTypeMetadata]:
        """
        Get metadata for a log type.

        Args:
            name: Log type name

        Returns:
            LogTypeMetadata or None if not found
        """
        return self._registry.get(name)

    def get_metadata_or_raise(self, name: str) -> LogTypeMetadata:
        """
        Get metadata for a log type, raising if not found.

        Args:
            name: Log type name

        Returns:
            LogTypeMetadata

        Raises:
            LogTypeNotFoundError: If log type not registered
        """
        metadata = self._registry.get(name)
        if metadata is None:
            raise LogTypeNotFoundError(name, available=list(self._registry.keys()))
        return metadata

    def get_generator(self, name: str) -> Optional[Type[BaseLogGenerator]]:
        """
        Get generator class for a log type.

        Args:
            name: Log type name

        Returns:
            Generator class or None if not found
        """
        return self._generators.get(name)

    def get_generator_or_raise(self, name: str) -> Type[BaseLogGenerator]:
        """
        Get generator class for a log type, raising if not found.

        Args:
            name: Log type name

        Returns:
            Generator class

        Raises:
            LogTypeNotFoundError: If log type not registered
        """
        generator = self._generators.get(name)
        if generator is None:
            raise LogTypeNotFoundError(name, available=list(self._generators.keys()))
        return generator

    def get_by_category(self, category: LogCategory) -> List[str]:
        """
        Get all log types in a category.

        Args:
            category: The category to filter by

        Returns:
            List of log type names in the category
        """
        return [
            name for name, meta in self._registry.items() if meta.category == category
        ]

    def get_by_recurrence(self, pattern: RecurrencePattern) -> List[str]:
        """
        Get all log types with a specific recurrence pattern.

        Args:
            pattern: The recurrence pattern to filter by

        Returns:
            List of log type names with the pattern
        """
        return [
            name for name, meta in self._registry.items() if meta.recurrence == pattern
        ]

    def get_by_severity(self, severity: LogSeverity) -> List[str]:
        """
        Get all log types with a specific severity.

        Args:
            severity: The severity to filter by

        Returns:
            List of log type names with the severity
        """
        return [
            name for name, meta in self._registry.items() if meta.severity == severity
        ]

    def get_by_tag(self, tag: str) -> List[str]:
        """
        Get all log types with a specific tag.

        Args:
            tag: The tag to filter by

        Returns:
            List of log type names with the tag
        """
        return [name for name, meta in self._registry.items() if tag in meta.tags]

    def all_types(self) -> List[str]:
        """
        Get all registered log type names.

        Returns:
            List of all log type names
        """
        return list(self._registry.keys())

    def all_metadata(self) -> Dict[str, LogTypeMetadata]:
        """
        Get all registered metadata.

        Returns:
            Dictionary mapping names to metadata
        """
        return dict(self._registry)

    def count(self) -> int:
        """
        Get the number of registered log types.

        Returns:
            Number of registered types
        """
        return len(self._registry)

    def is_registered(self, name: str) -> bool:
        """
        Check if a log type is registered.

        Args:
            name: Log type name

        Returns:
            True if registered, False otherwise
        """
        return name in self._registry

    def categories_summary(self) -> Dict[LogCategory, int]:
        """
        Get a summary of log types by category.

        Returns:
            Dictionary mapping categories to counts
        """
        summary: Dict[LogCategory, int] = {}
        for meta in self._registry.values():
            summary[meta.category] = summary.get(meta.category, 0) + 1
        return summary


def register_log_type(
    name: str,
    category: LogCategory,
    severity: LogSeverity,
    recurrence: RecurrencePattern,
    description: str,
    text_template: str,
    tags: Optional[List[str]] = None,
) -> Callable[[Type[BaseLogGenerator]], Type[BaseLogGenerator]]:
    """
    Decorator to register a log generator class.

    This decorator registers the log type in the global registry
    when the class is defined, making it available for generation.

    Usage:
        @register_log_type(
            name="player.login",
            category=LogCategory.PLAYER,
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Player login event",
            text_template="[{timestamp}] LOGIN: {username} from {ip}"
        )
        class PlayerLoginGenerator(BaseLogGenerator):
            def _generate_data(self, **kwargs):
                return {"username": "...", "ip": "..."}

    Args:
        name: Unique log type identifier (e.g., "player.login")
        category: Which category this log belongs to
        severity: Default severity level
        recurrence: How often this log type fires
        description: Human-readable description
        text_template: Printf-style template for text output
        tags: Optional list of tags for filtering

    Returns:
        Decorator function that registers the class
    """

    def decorator(cls: Type[BaseLogGenerator]) -> Type[BaseLogGenerator]:
        registry = LogTypeRegistry()
        metadata = LogTypeMetadata(
            name=name,
            category=category,
            severity=severity,
            recurrence=recurrence,
            description=description,
            text_template=text_template,
            tags=tuple(tags) if tags else (),
        )
        registry.register(name, metadata, cls)
        # Store metadata on the class for introspection
        cls._log_type_metadata = metadata  # type: ignore
        return cls

    return decorator


# Convenience function to get the global registry
def get_registry() -> LogTypeRegistry:
    """
    Get the global log type registry.

    Returns:
        The singleton LogTypeRegistry instance
    """
    return LogTypeRegistry()


def register_lua_generators(resources_path: Optional[Union[str, Path]] = None) -> int:
    """
    Load and register all Lua generators.

    This function loads all Lua generators and registers them
    with the main LogTypeRegistry, making them available alongside
    Python generators.

    Args:
        resources_path: Optional path to resources directory

    Returns:
        Number of Lua generators registered
    """
    from mmofakelog.core.lua_adapter import get_lua_registry, LuaGeneratorAdapter

    lua_registry = get_lua_registry()
    main_registry = get_registry()

    # Load generators
    generators_path = None
    if resources_path:
        generators_path = Path(resources_path) / "generators"

    count = lua_registry.load_generators(generators_path)

    # Register adapters with main registry
    for name in lua_registry.all_types():
        adapter = lua_registry.get_adapter(name)
        metadata = lua_registry.get_metadata(name)

        if adapter and metadata and not main_registry.is_registered(name):
            # Create a wrapper class that returns the adapter instance
            # This allows the factory to work with both Python classes and Lua adapters
            class _LuaGeneratorWrapper:
                _adapter = adapter
                _log_type_metadata = metadata

                def __new__(cls) -> LuaGeneratorAdapter:
                    return cls._adapter

            main_registry.register(name, metadata, _LuaGeneratorWrapper)

    return count
