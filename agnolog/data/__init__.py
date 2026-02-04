"""
Game data module.

Data is now stored in YAML files under resources/data/.
This module is kept for backwards compatibility but the data
modules have been migrated to the data-driven YAML system.

To access data, use the ResourceLoader:
    from agnolog.core.resource_loader import ResourceLoader

    loader = ResourceLoader()
    data = loader.load_all_nested()
    names = data.get("names", {})
"""

__all__ = []
