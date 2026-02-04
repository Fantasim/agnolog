"""
Resource loader for YAML data files.

Loads and caches YAML data files from the resources directory,
providing a unified interface for accessing game data.
"""

from __future__ import annotations

import logging
from pathlib import Path
from typing import Any, Dict, List, Optional, Union

import yaml

logger = logging.getLogger(__name__)


class ResourceLoader:
    """
    Loads and caches YAML resource files.

    Provides lazy loading with caching for efficient access to game data.
    Files are loaded on first access and cached for subsequent requests.

    Usage:
        loader = ResourceLoader()
        names = loader.get("names.player_prefixes")
        zones = loader.get("world.zones")
    """

    _instance: Optional[ResourceLoader] = None

    def __new__(cls, resource_path: Optional[Path] = None) -> ResourceLoader:
        """Ensure singleton instance (can be reset with new path)."""
        if cls._instance is None or resource_path is not None:
            instance = super().__new__(cls)
            instance._initialized = False
            cls._instance = instance
        return cls._instance

    def __init__(self, resource_path: Optional[Path] = None) -> None:
        """
        Initialize the resource loader.

        Args:
            resource_path: Path to the resources directory.
                          Must be provided - there is no default.

        Raises:
            ValueError: If resource_path is None and no instance exists.
        """
        if self._initialized and resource_path is None:
            return

        if resource_path is None:
            raise ValueError(
                "resource_path is required. "
                "Use --resources CLI argument to specify the resources directory."
            )

        self._resource_path = resource_path
        self._data_path = resource_path / "data"
        self._cache: Dict[str, Any] = {}
        self._all_data: Optional[Dict[str, Any]] = None
        self._initialized = True

    @classmethod
    def reset(cls) -> None:
        """Reset the singleton instance (for testing)."""
        cls._instance = None

    @property
    def resource_path(self) -> Path:
        """Get the resource path."""
        return self._resource_path

    @property
    def data_path(self) -> Path:
        """Get the data path."""
        return self._data_path

    def load_yaml_file(self, file_path: Path) -> Any:
        """
        Load a single YAML file.

        Args:
            file_path: Path to the YAML file

        Returns:
            Parsed YAML content

        Raises:
            FileNotFoundError: If file doesn't exist
            yaml.YAMLError: If YAML is invalid
        """
        if not file_path.exists():
            raise FileNotFoundError(f"Resource file not found: {file_path}")

        with open(file_path, "r", encoding="utf-8") as f:
            return yaml.safe_load(f)

    def _path_to_key(self, file_path: Path) -> str:
        """
        Convert a file path to a dot-notation key.

        Args:
            file_path: Path relative to data directory

        Returns:
            Dot-notation key like "names.player_prefixes"
        """
        relative = file_path.relative_to(self._data_path)
        return str(relative.with_suffix("")).replace("/", ".").replace("\\", ".")

    def _key_to_path(self, key: str) -> Path:
        """
        Convert a dot-notation key to a file path.

        Args:
            key: Dot-notation key like "names.player_prefixes"

        Returns:
            Path to the YAML file
        """
        parts = key.split(".")
        return self._data_path.joinpath(*parts).with_suffix(".yaml")

    def get(self, key: str, default: Any = None) -> Any:
        """
        Get data by dot-notation key.

        Args:
            key: Dot-notation path like "names.player_prefixes"
            default: Default value if not found

        Returns:
            The loaded data or default
        """
        if key in self._cache:
            return self._cache[key]

        file_path = self._key_to_path(key)
        if not file_path.exists():
            logger.debug(f"Resource not found: {key} ({file_path})")
            return default

        try:
            data = self.load_yaml_file(file_path)
            self._cache[key] = data
            return data
        except Exception as e:
            logger.error(f"Error loading resource {key}: {e}")
            return default

    def get_data(self, key: str) -> Any:
        """
        Get the 'data' section from a resource file.

        Many resource files have a structure like:
            version: "1.0"
            metadata: {...}
            data: {...}

        This method returns just the 'data' portion.

        Args:
            key: Dot-notation path

        Returns:
            The 'data' section or the entire content if no 'data' key
        """
        content = self.get(key)
        if content is None:
            return None
        if isinstance(content, dict) and "data" in content:
            return content["data"]
        return content

    def load_all(self) -> Dict[str, Any]:
        """
        Load all YAML files into a nested dictionary.

        Returns:
            Nested dictionary with all data, keyed by dot-notation paths
        """
        if self._all_data is not None:
            return self._all_data

        self._all_data = {}

        if not self._data_path.exists():
            logger.warning(f"Data path does not exist: {self._data_path}")
            return self._all_data

        for yaml_file in self._data_path.rglob("*.yaml"):
            key = self._path_to_key(yaml_file)
            try:
                data = self.load_yaml_file(yaml_file)
                self._cache[key] = data
                # Extract just the data section if present
                if isinstance(data, dict) and "data" in data:
                    self._all_data[key] = data["data"]
                else:
                    self._all_data[key] = data
            except Exception as e:
                logger.error(f"Error loading {yaml_file}: {e}")

        return self._all_data

    def load_all_nested(self) -> Dict[str, Any]:
        """
        Load all YAML files into a nested structure.

        Instead of flat keys like "names.player_prefixes",
        creates nested dicts like data["names"]["player_prefixes"].

        Returns:
            Nested dictionary structure
        """
        flat = self.load_all()
        nested: Dict[str, Any] = {}

        for key, value in flat.items():
            parts = key.split(".")
            current = nested
            for part in parts[:-1]:
                if part not in current:
                    current[part] = {}
                current = current[part]
            current[parts[-1]] = value

        return nested

    def list_resources(self, category: Optional[str] = None) -> List[str]:
        """
        List available resource keys.

        Args:
            category: Optional category prefix to filter by

        Returns:
            List of resource keys
        """
        if not self._data_path.exists():
            return []

        keys = []
        for yaml_file in self._data_path.rglob("*.yaml"):
            key = self._path_to_key(yaml_file)
            if category is None or key.startswith(category):
                keys.append(key)

        return sorted(keys)

    def reload(self, key: Optional[str] = None) -> None:
        """
        Reload resources from disk.

        Args:
            key: Specific key to reload, or None to clear all cache
        """
        if key is None:
            self._cache.clear()
            self._all_data = None
        elif key in self._cache:
            del self._cache[key]
            if self._all_data and key in self._all_data:
                del self._all_data[key]

    def validate(self) -> List[str]:
        """
        Validate all resource files.

        Returns:
            List of error messages (empty if all valid)
        """
        errors = []

        if not self._data_path.exists():
            errors.append(f"Data path does not exist: {self._data_path}")
            return errors

        for yaml_file in self._data_path.rglob("*.yaml"):
            try:
                self.load_yaml_file(yaml_file)
            except yaml.YAMLError as e:
                errors.append(f"Invalid YAML in {yaml_file}: {e}")
            except Exception as e:
                errors.append(f"Error loading {yaml_file}: {e}")

        return errors


def get_resource_loader(resource_path: Optional[Path] = None) -> ResourceLoader:
    """
    Get the global resource loader instance.

    Args:
        resource_path: Optional path to initialize with

    Returns:
        The singleton ResourceLoader instance
    """
    return ResourceLoader(resource_path)
