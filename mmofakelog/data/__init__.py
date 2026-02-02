"""
Game data module for generating realistic MMORPG content.

Provides data generators for:
- Player/NPC names
- Items (weapons, armor, consumables)
- Zones and locations
- Quests
- Skills and abilities
- Monsters and NPCs

Usage:
    from mmofakelog.data import generate_player_name, generate_item, ZONES

    name = generate_player_name()
    item = generate_item(rarity="Rare")
    zone = random.choice(ZONES)
"""

from mmofakelog.data.names import (
    generate_player_name,
    generate_character_name,
    generate_npc_name,
    generate_guild_name,
    generate_ip_address,
    generate_session_id,
)
from mmofakelog.data.items import (
    generate_item,
    generate_item_name,
    ITEM_TYPES,
    WEAPON_TYPES,
    ARMOR_TYPES,
)
from mmofakelog.data.zones import (
    ZONES,
    DUNGEONS,
    RAIDS,
    CITIES,
    generate_zone,
    generate_location,
)
from mmofakelog.data.quests import (
    generate_quest,
    generate_quest_name,
    QUEST_TYPES,
)
from mmofakelog.data.skills import (
    generate_skill,
    SKILLS_BY_CLASS,
)
from mmofakelog.data.monsters import (
    generate_monster,
    generate_boss,
    MONSTER_TYPES,
)

__all__ = [
    # Names
    "generate_player_name",
    "generate_character_name",
    "generate_npc_name",
    "generate_guild_name",
    "generate_ip_address",
    "generate_session_id",
    # Items
    "generate_item",
    "generate_item_name",
    "ITEM_TYPES",
    "WEAPON_TYPES",
    "ARMOR_TYPES",
    # Zones
    "ZONES",
    "DUNGEONS",
    "RAIDS",
    "CITIES",
    "generate_zone",
    "generate_location",
    # Quests
    "generate_quest",
    "generate_quest_name",
    "QUEST_TYPES",
    # Skills
    "generate_skill",
    "SKILLS_BY_CLASS",
    # Monsters
    "generate_monster",
    "generate_boss",
    "MONSTER_TYPES",
]
