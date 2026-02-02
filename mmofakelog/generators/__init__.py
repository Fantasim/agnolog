"""
Log generators module.

Contains all 105+ log type generators organized by category:
- player: Player actions (login, combat, chat, inventory, etc.)
- server: Server events (start/stop, performance, world events)
- security: Security and admin actions (bans, suspicious activity)
- economy: Economic transactions (trades, auctions, vendors)
- combat: Combat events (damage, dungeons, raids, PvP)
- technical: Technical logs (connections, packets, errors)

Usage:
    # Generators are auto-registered via decorators
    # Use the factory to create log entries:
    from mmofakelog import LogFactory

    factory = LogFactory()
    entry = factory.create("player.login")

    # Or import specific generators for direct use:
    from mmofakelog.generators.player import PlayerLoginGenerator
"""

# Import all generators to trigger registration
from mmofakelog.generators import player
from mmofakelog.generators import server
from mmofakelog.generators import security
from mmofakelog.generators import economy
from mmofakelog.generators import combat
from mmofakelog.generators import technical

# Re-export base class
from mmofakelog.generators.base import BaseLogGenerator

__all__ = [
    "BaseLogGenerator",
    "player",
    "server",
    "security",
    "economy",
    "combat",
    "technical",
]
