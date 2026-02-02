"""
Monster and NPC data for the fake log system.

Provides monster types, bosses, and related generators.
"""

import random
from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple

from mmofakelog.core.constants import MAX_PLAYER_LEVEL

# =============================================================================
# MONSTER TYPE DEFINITIONS
# =============================================================================

MONSTER_TYPES: Tuple[str, ...] = (
    "Beast", "Humanoid", "Undead", "Demon", "Elemental",
    "Dragon", "Giant", "Mechanical", "Aberration", "Dragonkin",
)

# =============================================================================
# MONSTER NAME COMPONENTS
# =============================================================================

MONSTER_PREFIXES: Dict[str, Tuple[str, ...]] = {
    "Beast": ("Wild", "Rabid", "Feral", "Savage", "Dire"),
    "Humanoid": ("Defias", "Scarlet", "Syndicate", "Dark Iron", "Bloodsail"),
    "Undead": ("Rotting", "Skeletal", "Spectral", "Plagued", "Risen"),
    "Demon": ("Fel", "Burning", "Shadowy", "Corrupted", "Void"),
    "Elemental": ("Raging", "Primal", "Ancient", "Volatile", "Infused"),
    "Dragon": ("Young", "Adult", "Elder", "Ancient", "Twilight"),
    "Giant": ("Mountain", "Forest", "Sea", "Storm", "Fire"),
    "Mechanical": ("Defective", "Upgraded", "Prototype", "Combat", "Assault"),
    "Aberration": ("Twisted", "Mutated", "Eldritch", "Faceless", "Void"),
    "Dragonkin": ("Blackwing", "Bronze", "Blue", "Green", "Red"),
}

MONSTER_NAMES: Dict[str, Tuple[str, ...]] = {
    "Beast": ("Wolf", "Bear", "Spider", "Boar", "Cat", "Raptor", "Gorilla", "Bat"),
    "Humanoid": ("Bandit", "Cultist", "Pirate", "Thug", "Scout", "Assassin"),
    "Undead": ("Zombie", "Skeleton", "Ghost", "Ghoul", "Wraith", "Banshee"),
    "Demon": ("Imp", "Felguard", "Doomguard", "Succubus", "Infernal"),
    "Elemental": ("Fire Elemental", "Water Elemental", "Earth Elemental", "Air Elemental"),
    "Dragon": ("Drake", "Whelp", "Dragon", "Wyrm"),
    "Giant": ("Ogre", "Ettin", "Gronn", "Titan", "Colossus"),
    "Mechanical": ("Golem", "Harvester", "Shredder", "Walker"),
    "Aberration": ("Tentacle", "Eye", "Ooze", "Horror"),
    "Dragonkin": ("Dragonspawn", "Drakonid", "Wyrmkin"),
}

ELITE_TITLES: Tuple[str, ...] = (
    "Champion", "Warlord", "Commander", "Chieftain", "Alpha",
    "Overlord", "Deathlord", "Archon", "Enforcer", "Executioner",
)

# =============================================================================
# BOSS DEFINITIONS
# =============================================================================

# Dungeon bosses
DUNGEON_BOSSES: Dict[str, Tuple[str, ...]] = {
    "Deadmines": ("Rhahk'Zor", "Sneed", "Gilnid", "Mr. Smite", "Edwin VanCleef"),
    "Wailing Caverns": ("Lady Anacondra", "Lord Pythas", "Lord Cobrahn", "Mutanus the Devourer"),
    "Shadowfang Keep": ("Baron Silverlaine", "Commander Springvale", "Lord Walden", "Lord Godfrey"),
    "Scarlet Monastery": ("High Inquisitor Whitemane", "Scarlet Commander Mograine", "Herod"),
    "Blackrock Depths": ("Emperor Dagran Thaurissan", "Princess Moira", "High Priestess of Thaurissan"),
    "Stratholme": ("Baron Rivendare", "Ramstein the Gorger", "Magistrate Barthilas"),
    "Scholomance": ("Darkmaster Gandling", "Rattlegore", "Instructor Malicia"),
}

# Raid bosses
RAID_BOSSES: Dict[str, Tuple[str, ...]] = {
    "Molten Core": (
        "Lucifron", "Magmadar", "Gehennas", "Garr", "Shazzrah",
        "Baron Geddon", "Golemagg the Incinerator", "Sulfuron Harbinger",
        "Majordomo Executus", "Ragnaros",
    ),
    "Blackwing Lair": (
        "Razorgore the Untamed", "Vaelastrasz the Corrupt", "Broodlord Lashlayer",
        "Firemaw", "Ebonroc", "Flamegor", "Chromaggus", "Nefarian",
    ),
    "Temple of Ahn'Qiraj": (
        "The Prophet Skeram", "Battleguard Sartura", "Fankriss the Unyielding",
        "Princess Huhuran", "Twin Emperors", "Ouro", "C'Thun",
    ),
    "Naxxramas": (
        "Anub'Rekhan", "Grand Widow Faerlina", "Maexxna",
        "Patchwerk", "Grobbulus", "Gluth", "Thaddius",
        "Gothik the Harvester", "The Four Horsemen",
        "Sapphiron", "Kel'Thuzad",
    ),
}

# World bosses
WORLD_BOSSES: Tuple[str, ...] = (
    "Azuregos", "Lord Kazzak", "Emeriss", "Lethon", "Taerar", "Ysondre",
    "Doom Lord Kazzak", "Doomwalker",
)

# =============================================================================
# MONSTER DATA STRUCTURE
# =============================================================================


@dataclass
class Monster:
    """Represents a monster/NPC."""
    monster_id: int
    name: str
    monster_type: str
    level: int
    is_elite: bool
    is_boss: bool
    is_rare: bool
    health: int
    zone: str

    def __str__(self) -> str:
        prefix = ""
        if self.is_boss:
            prefix = "[Boss] "
        elif self.is_elite:
            prefix = "[Elite] "
        elif self.is_rare:
            prefix = "[Rare] "
        return f"{prefix}{self.name}"


# =============================================================================
# MONSTER GENERATORS
# =============================================================================


def generate_monster_name(
    monster_type: str,
    is_elite: bool = False,
) -> str:
    """
    Generate a monster name.

    Args:
        monster_type: Type of monster
        is_elite: Whether this is an elite

    Returns:
        Generated monster name
    """
    prefixes = MONSTER_PREFIXES.get(monster_type, ("Wild",))
    names = MONSTER_NAMES.get(monster_type, ("Creature",))

    prefix = random.choice(prefixes)
    name = random.choice(names)

    if is_elite:
        title = random.choice(ELITE_TITLES)
        return f"{prefix} {name} {title}"

    return f"{prefix} {name}"


def generate_monster(
    monster_type: Optional[str] = None,
    level: Optional[int] = None,
    zone: Optional[str] = None,
    is_elite: Optional[bool] = None,
) -> Monster:
    """
    Generate a random monster.

    Args:
        monster_type: Specific type (random if None)
        level: Monster level (random if None)
        zone: Zone where monster spawns
        is_elite: Whether elite (random if None)

    Returns:
        Generated Monster object
    """
    from mmofakelog.data.zones import generate_zone

    if monster_type is None:
        monster_type = random.choice(MONSTER_TYPES)

    if level is None:
        level = random.randint(1, MAX_PLAYER_LEVEL)

    if zone is None:
        zone = generate_zone(level=level)

    if is_elite is None:
        is_elite = random.random() < 0.1  # 10% chance

    # Rare spawns
    is_rare = random.random() < 0.02  # 2% chance

    # Calculate health based on level and elite status
    base_health = level * 100
    if is_elite:
        base_health *= 5
    if is_rare:
        base_health *= 3

    health = int(base_health * random.uniform(0.8, 1.2))

    return Monster(
        monster_id=random.randint(10000, 99999),
        name=generate_monster_name(monster_type, is_elite),
        monster_type=monster_type,
        level=level,
        is_elite=is_elite,
        is_boss=False,
        is_rare=is_rare,
        health=health,
        zone=zone,
    )


def generate_boss(
    dungeon: Optional[str] = None,
    raid: Optional[str] = None,
) -> Monster:
    """
    Generate a boss monster.

    Args:
        dungeon: Specific dungeon (for dungeon bosses)
        raid: Specific raid (for raid bosses)

    Returns:
        Generated boss Monster object
    """
    if raid:
        bosses = RAID_BOSSES.get(raid, RAID_BOSSES["Molten Core"])
        name = random.choice(bosses)
        zone = raid
        level = 60
        health = random.randint(500000, 5000000)
    elif dungeon:
        bosses = DUNGEON_BOSSES.get(dungeon, list(DUNGEON_BOSSES.values())[0])
        name = random.choice(bosses)
        zone = dungeon
        level = random.randint(20, 60)
        health = random.randint(50000, 500000)
    else:
        # World boss
        name = random.choice(WORLD_BOSSES)
        from mmofakelog.data.zones import generate_zone
        zone = generate_zone()
        level = 60
        health = random.randint(1000000, 10000000)

    return Monster(
        monster_id=random.randint(10000, 99999),
        name=name,
        monster_type="Boss",
        level=level,
        is_elite=True,
        is_boss=True,
        is_rare=False,
        health=health,
        zone=zone,
    )


def generate_world_boss() -> Monster:
    """Generate a world boss."""
    name = random.choice(WORLD_BOSSES)
    from mmofakelog.data.zones import generate_zone

    return Monster(
        monster_id=random.randint(10000, 99999),
        name=name,
        monster_type="Boss",
        level=60,
        is_elite=True,
        is_boss=True,
        is_rare=True,
        health=random.randint(5000000, 20000000),
        zone=generate_zone(),
    )
