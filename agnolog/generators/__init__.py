"""
Log generators module.

Generators are now implemented in Lua under resources/generators/.
Python generators have been migrated to the data-driven Lua system.

The BaseLogGenerator class is kept for compatibility and can be used
for custom Python generators if needed.

Usage:
    from agnolog import LogFactory

    factory = LogFactory()
    entry = factory.create("player.login")
"""

# Re-export base class for any custom Python generators
from agnolog.generators.base import BaseLogGenerator

__all__ = [
    "BaseLogGenerator",
]
