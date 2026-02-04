"""
Adapter for Lua generators.

Wraps Lua generators to implement the BaseLogGenerator interface,
allowing them to be used seamlessly with the existing registry and factory.
"""

from __future__ import annotations

import logging
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional, Type

from agnolog.core.types import (
    LogEntry,
    LogSeverity,
    LogTypeMetadata,
    RecurrencePattern,
)

logger = logging.getLogger(__name__)


# String to enum mappings
SEVERITY_MAP = {
    "DEBUG": LogSeverity.DEBUG,
    "INFO": LogSeverity.INFO,
    "WARNING": LogSeverity.WARNING,
    "ERROR": LogSeverity.ERROR,
    "CRITICAL": LogSeverity.CRITICAL,
}

RECURRENCE_MAP = {
    "VERY_FREQUENT": RecurrencePattern.VERY_FREQUENT,
    "FREQUENT": RecurrencePattern.FREQUENT,
    "NORMAL": RecurrencePattern.NORMAL,
    "INFREQUENT": RecurrencePattern.INFREQUENT,
    "RARE": RecurrencePattern.RARE,
}


def metadata_from_lua(lua_metadata: Dict[str, Any]) -> LogTypeMetadata:
    """
    Convert Lua metadata dict to LogTypeMetadata.

    Args:
        lua_metadata: Dict with metadata from Lua generator

    Returns:
        LogTypeMetadata instance

    Raises:
        ValueError: If required fields are missing or invalid
    """
    name = lua_metadata.get("name")
    if not name:
        raise ValueError("Lua metadata missing 'name'")

    # Category is now a flexible string
    category = lua_metadata.get("category", "GENERAL").upper()

    severity_str = lua_metadata.get("severity", "INFO")
    severity = SEVERITY_MAP.get(severity_str.upper())
    if severity is None:
        raise ValueError(f"Invalid severity: {severity_str}")

    recurrence_str = lua_metadata.get("recurrence", "NORMAL")
    recurrence = RECURRENCE_MAP.get(recurrence_str.upper())
    if recurrence is None:
        raise ValueError(f"Invalid recurrence: {recurrence_str}")

    description = lua_metadata.get("description", f"Generated log type: {name}")
    text_template = lua_metadata.get("text_template", "[{timestamp}] {log_type}")

    tags = lua_metadata.get("tags", [])
    if isinstance(tags, dict):
        # Lua table converted to dict with integer keys
        tags = list(tags.values())
    tags = tuple(str(t) for t in tags)

    # Extract merge_groups (optional, defaults to empty tuple)
    merge_groups = lua_metadata.get("merge_groups", [])
    if isinstance(merge_groups, dict):
        # Lua table converted to dict with integer keys
        merge_groups = list(merge_groups.values())
    merge_groups = tuple(str(g) for g in merge_groups)

    return LogTypeMetadata(
        name=name,
        category=category,
        severity=severity,
        recurrence=recurrence,
        description=description,
        text_template=text_template,
        tags=tags,
        merge_groups=merge_groups,
    )


class LuaGeneratorAdapter:
    """
    Adapter that wraps a Lua generator to work with the log system.

    This adapter:
    - Implements the same interface as BaseLogGenerator
    - Delegates generation to the Lua runtime
    - Converts between Python and Lua types
    """

    def __init__(
        self,
        name: str,
        metadata: LogTypeMetadata,
        lua_sandbox: Any,  # LuaSandbox instance
    ) -> None:
        """
        Initialize the adapter.

        Args:
            name: Generator name (e.g., "player.login")
            metadata: Converted LogTypeMetadata
            lua_sandbox: LuaSandbox instance for execution
        """
        self._name = name
        self._metadata = metadata
        self._lua_sandbox = lua_sandbox
        self._log_type_metadata = metadata  # For compatibility with BaseLogGenerator

    @property
    def name(self) -> str:
        """Get generator name."""
        return self._name

    @property
    def metadata(self) -> LogTypeMetadata:
        """Get generator metadata."""
        return self._metadata

    def generate(
        self,
        timestamp: datetime,
        metadata: LogTypeMetadata,
        server_id: Optional[str] = None,
        session_id: Optional[str] = None,
        **kwargs: Any,
    ) -> LogEntry:
        """
        Generate a log entry using the Lua generator.

        Args:
            timestamp: Log timestamp
            metadata: Log type metadata
            server_id: Optional server identifier
            session_id: Optional session identifier
            **kwargs: Additional generation parameters

        Returns:
            Complete LogEntry
        """
        try:
            # Call Lua generator
            data = self._lua_sandbox.generate(self._name, **kwargs)
        except Exception as e:
            logger.error(f"Error generating {self._name}: {e}")
            data = {"error": str(e)}

        return LogEntry(
            log_type=metadata.name,
            timestamp=timestamp,
            severity=metadata.severity,
            category=metadata.category,
            data=data,
            server_id=server_id,
            session_id=session_id,
        )

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        """
        Generate data dict (for compatibility with BaseLogGenerator).

        Args:
            **kwargs: Generation parameters

        Returns:
            Generated data dictionary
        """
        return self._lua_sandbox.generate(self._name, **kwargs)

    def __repr__(self) -> str:
        return f"LuaGeneratorAdapter(name={self._name})"


class LuaGeneratorRegistry:
    """
    Registry for Lua-based generators.

    Manages loading, registration, and access to Lua generators.
    Works alongside the Python registry for a unified interface.
    """

    _instance: Optional[LuaGeneratorRegistry] = None

    def __new__(cls) -> LuaGeneratorRegistry:
        """Ensure singleton instance."""
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._initialized = False
        return cls._instance

    def __init__(self) -> None:
        """Initialize the registry."""
        if self._initialized:
            return

        self._adapters: Dict[str, LuaGeneratorAdapter] = {}
        self._metadata: Dict[str, LogTypeMetadata] = {}
        self._lua_sandbox: Optional[Any] = None
        self._initialized = True

    @classmethod
    def reset(cls) -> None:
        """Reset the singleton instance (for testing)."""
        cls._instance = None

    def set_sandbox(self, sandbox: Any) -> None:
        """
        Set the Lua sandbox instance.

        Args:
            sandbox: LuaSandbox instance
        """
        self._lua_sandbox = sandbox

    def load_generators(
        self,
        generators_path: Optional[Path] = None,
        resources_path: Optional[Path] = None,
    ) -> int:
        """
        Load all Lua generators.

        Args:
            generators_path: Path to generators directory
            resources_path: Path to resources directory (for ResourceLoader)

        Returns:
            Number of generators loaded
        """
        if self._lua_sandbox is None:
            from agnolog.core.lua_runtime import LuaSandbox
            from agnolog.core.resource_loader import ResourceLoader

            resource_loader = ResourceLoader(resource_path=resources_path)
            self._lua_sandbox = LuaSandbox(resource_loader=resource_loader)

        # Load generators through sandbox
        all_metadata = self._lua_sandbox.load_all_generators(generators_path)

        # Create adapters
        for name, lua_meta in all_metadata.items():
            try:
                metadata = metadata_from_lua(lua_meta)
                adapter = LuaGeneratorAdapter(name, metadata, self._lua_sandbox)
                self._adapters[name] = adapter
                self._metadata[name] = metadata
            except Exception as e:
                logger.error(f"Failed to create adapter for {name}: {e}")

        return len(self._adapters)

    def get_adapter(self, name: str) -> Optional[LuaGeneratorAdapter]:
        """
        Get adapter for a generator.

        Args:
            name: Generator name

        Returns:
            LuaGeneratorAdapter or None
        """
        return self._adapters.get(name)

    def get_metadata(self, name: str) -> Optional[LogTypeMetadata]:
        """
        Get metadata for a generator.

        Args:
            name: Generator name

        Returns:
            LogTypeMetadata or None
        """
        return self._metadata.get(name)

    def all_types(self) -> List[str]:
        """Get all registered generator names."""
        return list(self._adapters.keys())

    def all_metadata(self) -> Dict[str, LogTypeMetadata]:
        """Get all metadata."""
        return dict(self._metadata)

    def is_registered(self, name: str) -> bool:
        """Check if a generator is registered."""
        return name in self._adapters

    def count(self) -> int:
        """Get number of registered generators."""
        return len(self._adapters)

    def get_by_category(self, category: str) -> List[str]:
        """Get all generator names in a category."""
        return [
            name for name, meta in self._metadata.items()
            if meta.category == category
        ]

    def get_by_recurrence(self, pattern: RecurrencePattern) -> List[str]:
        """Get all generator names with a recurrence pattern."""
        return [
            name for name, meta in self._metadata.items()
            if meta.recurrence == pattern
        ]

    def get_by_severity(self, severity: LogSeverity) -> List[str]:
        """Get all generator names with a severity."""
        return [
            name for name, meta in self._metadata.items()
            if meta.severity == severity
        ]

    def get_by_tag(self, tag: str) -> List[str]:
        """Get all generator names with a tag."""
        return [
            name for name, meta in self._metadata.items()
            if tag in meta.tags
        ]


def get_lua_registry() -> LuaGeneratorRegistry:
    """
    Get the global Lua generator registry.

    Returns:
        The singleton LuaGeneratorRegistry instance
    """
    return LuaGeneratorRegistry()
