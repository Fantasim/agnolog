"""
Zone and location data for the fake log system.

Provides zone names, locations, and related generators.
"""

import random
from dataclasses import dataclass
from typing import List, Optional, Tuple

# =============================================================================
# ZONE DEFINITIONS
# =============================================================================

# Starting zones (levels 1-10)
STARTING_ZONES: Tuple[str, ...] = (
    "Elwynn Forest", "Durotar", "Mulgore", "Teldrassil", "Tirisfal Glades",
    "Dun Morogh", "Eversong Woods", "Azuremyst Isle", "Gilneas", "Kezan",
)

# Low-level zones (levels 10-20)
LOW_LEVEL_ZONES: Tuple[str, ...] = (
    "Westfall", "Loch Modan", "Darkshore", "Silverpine Forest",
    "The Barrens", "Ghostlands", "Bloodmyst Isle", "Redridge Mountains",
)

# Mid-level zones (levels 20-40)
MID_LEVEL_ZONES: Tuple[str, ...] = (
    "Duskwood", "Wetlands", "Ashenvale", "Stonetalon Mountains",
    "Thousand Needles", "Hillsbrad Foothills", "Arathi Highlands",
    "Stranglethorn Vale", "Desolace", "Dustwallow Marsh", "Feralas",
    "Tanaris", "The Hinterlands", "Swamp of Sorrows",
)

# High-level zones (levels 40-60)
HIGH_LEVEL_ZONES: Tuple[str, ...] = (
    "Searing Gorge", "Blasted Lands", "Burning Steppes", "Felwood",
    "Un'Goro Crater", "Azshara", "Winterspring", "Silithus",
    "Western Plaguelands", "Eastern Plaguelands", "Deadwind Pass",
)

# All world zones
ZONES: Tuple[str, ...] = (
    STARTING_ZONES + LOW_LEVEL_ZONES + MID_LEVEL_ZONES + HIGH_LEVEL_ZONES
)

# Capital cities
CITIES: Tuple[str, ...] = (
    "Stormwind City", "Ironforge", "Darnassus", "The Exodar",
    "Orgrimmar", "Thunder Bluff", "Undercity", "Silvermoon City",
    "Shattrath City", "Dalaran",
)

# Dungeons with level ranges
DUNGEONS: Tuple[Tuple[str, int, int], ...] = (
    # (name, min_level, max_level)
    ("Ragefire Chasm", 13, 18),
    ("Deadmines", 17, 26),
    ("Wailing Caverns", 17, 24),
    ("Shadowfang Keep", 22, 30),
    ("Blackfathom Deeps", 24, 32),
    ("Stormwind Stockade", 24, 32),
    ("Gnomeregan", 29, 38),
    ("Razorfen Kraul", 29, 38),
    ("Scarlet Monastery", 34, 45),
    ("Razorfen Downs", 37, 46),
    ("Uldaman", 41, 51),
    ("Zul'Farrak", 44, 54),
    ("Maraudon", 46, 55),
    ("Temple of Atal'Hakkar", 50, 56),
    ("Blackrock Depths", 52, 60),
    ("Lower Blackrock Spire", 55, 60),
    ("Upper Blackrock Spire", 55, 60),
    ("Dire Maul", 55, 60),
    ("Stratholme", 58, 60),
    ("Scholomance", 58, 60),
)

# Raids
RAIDS: Tuple[Tuple[str, int, int], ...] = (
    # (name, raid_size, level)
    ("Molten Core", 40, 60),
    ("Onyxia's Lair", 40, 60),
    ("Blackwing Lair", 40, 60),
    ("Zul'Gurub", 20, 60),
    ("Ruins of Ahn'Qiraj", 20, 60),
    ("Temple of Ahn'Qiraj", 40, 60),
    ("Naxxramas", 40, 60),
)

# Battlegrounds
BATTLEGROUNDS: Tuple[str, ...] = (
    "Warsong Gulch",
    "Arathi Basin",
    "Alterac Valley",
    "Eye of the Storm",
    "Strand of the Ancients",
    "Isle of Conquest",
)

# Arenas
ARENAS: Tuple[str, ...] = (
    "Blade's Edge Arena",
    "Nagrand Arena",
    "Ruins of Lordaeron",
    "Ring of Valor",
    "Dalaran Sewers",
)

# =============================================================================
# LOCATION DATA STRUCTURE
# =============================================================================


@dataclass
class Location:
    """Represents a specific location in the game world."""
    zone: str
    subzone: Optional[str]
    x: float
    y: float
    z: float

    def __str__(self) -> str:
        if self.subzone:
            return f"{self.subzone}, {self.zone}"
        return self.zone


# =============================================================================
# ZONE GENERATORS
# =============================================================================


def get_zone_level_range(zone: str) -> Tuple[int, int]:
    """
    Get the level range for a zone.

    Args:
        zone: Zone name

    Returns:
        Tuple of (min_level, max_level)
    """
    if zone in STARTING_ZONES:
        return (1, 10)
    elif zone in LOW_LEVEL_ZONES:
        return (10, 20)
    elif zone in MID_LEVEL_ZONES:
        return (20, 40)
    elif zone in HIGH_LEVEL_ZONES:
        return (40, 60)
    elif zone in CITIES:
        return (1, 60)  # Cities have no level requirement
    else:
        return (1, 60)  # Default


def generate_zone(
    level: Optional[int] = None,
    include_cities: bool = False,
) -> str:
    """
    Generate a random zone name.

    Args:
        level: Optional player level to filter zones
        include_cities: Whether to include cities

    Returns:
        Zone name
    """
    available_zones: List[str] = []

    if level is None:
        available_zones = list(ZONES)
    else:
        for zone in ZONES:
            min_lvl, max_lvl = get_zone_level_range(zone)
            if min_lvl <= level <= max_lvl + 5:  # Allow some overlap
                available_zones.append(zone)

    if include_cities:
        available_zones.extend(CITIES)

    if not available_zones:
        available_zones = list(ZONES)

    return random.choice(available_zones)


def generate_location(zone: Optional[str] = None) -> Location:
    """
    Generate a random location.

    Args:
        zone: Specific zone (random if None)

    Returns:
        Location object
    """
    if zone is None:
        zone = generate_zone()

    # Generate random coordinates
    x = random.uniform(-5000, 5000)
    y = random.uniform(-5000, 5000)
    z = random.uniform(0, 500)

    # Some zones have subzones
    subzones = {
        "Elwynn Forest": ["Goldshire", "Northshire Valley", "Stone Cairn Lake"],
        "Durotar": ["Sen'jin Village", "Valley of Trials", "Razor Hill"],
        "Stormwind City": ["Trade District", "Cathedral Square", "Mage Quarter"],
        "Orgrimmar": ["Valley of Strength", "The Drag", "Valley of Wisdom"],
        "Stranglethorn Vale": ["Booty Bay", "Grom'gol Base Camp", "Nesingwary's Expedition"],
    }

    subzone = None
    if zone in subzones and random.random() < 0.5:
        subzone = random.choice(subzones[zone])

    return Location(
        zone=zone,
        subzone=subzone,
        x=round(x, 2),
        y=round(y, 2),
        z=round(z, 2),
    )


def generate_dungeon(level: Optional[int] = None) -> Tuple[str, int, int]:
    """
    Generate a random dungeon.

    Args:
        level: Optional player level to filter dungeons

    Returns:
        Tuple of (name, min_level, max_level)
    """
    if level is None:
        return random.choice(DUNGEONS)

    suitable = [d for d in DUNGEONS if d[1] <= level <= d[2] + 5]
    if not suitable:
        return random.choice(DUNGEONS)

    return random.choice(suitable)


def generate_raid() -> Tuple[str, int, int]:
    """
    Generate a random raid.

    Returns:
        Tuple of (name, raid_size, level)
    """
    return random.choice(RAIDS)


def generate_battleground() -> str:
    """Generate a random battleground name."""
    return random.choice(BATTLEGROUNDS)


def generate_arena() -> str:
    """Generate a random arena name."""
    return random.choice(ARENAS)


def get_faction_for_zone(zone: str) -> str:
    """
    Get the controlling faction for a zone.

    Args:
        zone: Zone name

    Returns:
        'Alliance', 'Horde', or 'Contested'
    """
    alliance_zones = {
        "Elwynn Forest", "Dun Morogh", "Teldrassil", "Azuremyst Isle",
        "Stormwind City", "Ironforge", "Darnassus", "The Exodar",
        "Westfall", "Loch Modan", "Darkshore", "Redridge Mountains",
    }
    horde_zones = {
        "Durotar", "Mulgore", "Tirisfal Glades", "Eversong Woods",
        "Orgrimmar", "Thunder Bluff", "Undercity", "Silvermoon City",
        "The Barrens", "Silverpine Forest", "Ghostlands",
    }

    if zone in alliance_zones:
        return "Alliance"
    elif zone in horde_zones:
        return "Horde"
    else:
        return "Contested"
