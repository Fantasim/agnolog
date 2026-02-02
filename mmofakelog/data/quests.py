"""
Quest data and generators for the fake log system.

Provides quest types, names, and related generators.
"""

import random
from dataclasses import dataclass, field
from typing import List, Optional, Tuple

from mmofakelog.core.constants import MAX_PLAYER_LEVEL, MAX_QUEST_XP, MIN_QUEST_XP

# =============================================================================
# QUEST TYPE DEFINITIONS
# =============================================================================

QUEST_TYPES: Tuple[str, ...] = (
    "Kill", "Collect", "Escort", "Delivery", "Exploration",
    "Dungeon", "Raid", "PvP", "Daily", "Weekly", "Story",
)

# =============================================================================
# QUEST NAME COMPONENTS
# =============================================================================

QUEST_VERBS: Tuple[str, ...] = (
    "Defeat", "Slay", "Vanquish", "Eliminate", "Destroy",
    "Collect", "Gather", "Retrieve", "Find", "Recover",
    "Deliver", "Escort", "Protect", "Rescue", "Save",
    "Explore", "Investigate", "Scout", "Discover", "Uncover",
    "Stop", "Prevent", "Thwart", "Foil", "End",
)

QUEST_TARGETS: Tuple[str, ...] = (
    "the Wolves", "the Bandits", "the Undead", "the Orcs", "the Trolls",
    "the Ancient Evil", "the Dark Lord", "the Dragon", "the Demon",
    "the Cursed Artifacts", "the Sacred Relics", "the Lost Treasure",
    "the Missing Supplies", "the Stolen Goods", "the Ancient Texts",
    "the Lost Explorer", "the Captured Villagers", "the Wounded Soldier",
    "the Hidden Shrine", "the Forgotten Temple", "the Secret Cave",
)

QUEST_LOCATIONS: Tuple[str, ...] = (
    "in the Forest", "at the Cave", "near the River", "by the Mountain",
    "in the Dungeon", "at the Tower", "within the Ruins", "beyond the Gate",
    "across the Bridge", "through the Valley", "inside the Castle",
)

QUEST_GIVERS: Tuple[str, ...] = (
    "Village Elder", "Town Guard", "Mysterious Stranger", "Royal Messenger",
    "Wounded Traveler", "Local Merchant", "Guild Master", "Ancient Spirit",
    "Wise Sage", "Battle Commander", "Concerned Farmer", "Desperate Mother",
)

# Story quest names (unique, epic)
STORY_QUESTS: Tuple[str, ...] = (
    "The Prophecy Unfolds",
    "Echoes of the Past",
    "The Final Stand",
    "Rise of the Shadow",
    "The Awakening",
    "Legacy of Heroes",
    "The Sundering",
    "Twilight of the Gods",
    "The Last Guardian",
    "Dawn of a New Age",
    "The Corrupted Heart",
    "Secrets of the Ancients",
)

# =============================================================================
# QUEST DATA STRUCTURE
# =============================================================================


@dataclass
class Quest:
    """Represents a game quest."""
    quest_id: int
    name: str
    quest_type: str
    level: int
    zone: str
    xp_reward: int
    gold_reward: int
    objectives: List[str] = field(default_factory=list)
    chain_position: Optional[int] = None  # Position in quest chain (1, 2, 3...)
    is_elite: bool = False
    is_group: bool = False

    def __str__(self) -> str:
        prefix = ""
        if self.is_elite:
            prefix = "[Elite] "
        elif self.is_group:
            prefix = "[Group] "
        return f"{prefix}{self.name}"


# =============================================================================
# QUEST GENERATORS
# =============================================================================


def generate_quest_name(quest_type: str, is_epic: bool = False) -> str:
    """
    Generate a quest name.

    Args:
        quest_type: Type of quest
        is_epic: Whether this is an epic/story quest

    Returns:
        Generated quest name
    """
    if is_epic or quest_type == "Story":
        return random.choice(STORY_QUESTS)

    verb = random.choice(QUEST_VERBS)
    target = random.choice(QUEST_TARGETS)

    # Some quest types have specific patterns
    if quest_type == "Kill":
        return f"{verb} {target}"
    elif quest_type == "Collect":
        return f"Collect {target}"
    elif quest_type == "Escort":
        return f"Escort {random.choice(QUEST_GIVERS)}"
    elif quest_type == "Delivery":
        return f"Deliver Supplies to {random.choice(QUEST_LOCATIONS)}"
    elif quest_type == "Exploration":
        return f"Explore {random.choice(QUEST_LOCATIONS)}"
    else:
        # Generic format
        location = random.choice(QUEST_LOCATIONS)
        return f"{verb} {target} {location}"


def generate_objectives(quest_type: str, count: int = 3) -> List[str]:
    """
    Generate quest objectives.

    Args:
        quest_type: Type of quest
        count: Number of objectives

    Returns:
        List of objective strings
    """
    objectives = []

    if quest_type == "Kill":
        mobs = ["Wolves", "Bears", "Spiders", "Bandits", "Cultists", "Undead"]
        for _ in range(min(count, 3)):
            mob = random.choice(mobs)
            num = random.choice([5, 8, 10, 12, 15])
            objectives.append(f"Kill {num} {mob}")

    elif quest_type == "Collect":
        items = ["Pelts", "Herbs", "Ore", "Crystals", "Artifacts", "Scrolls"]
        for _ in range(min(count, 3)):
            item = random.choice(items)
            num = random.choice([5, 8, 10, 15, 20])
            objectives.append(f"Collect {num} {item}")

    elif quest_type == "Escort":
        objectives.append("Meet the escort target")
        objectives.append("Protect the escort during travel")
        objectives.append("Reach the destination safely")

    elif quest_type == "Delivery":
        objectives.append("Pick up the package")
        objectives.append("Travel to the destination")
        objectives.append("Deliver the package")

    elif quest_type == "Exploration":
        locations = ["cave entrance", "ancient ruins", "hidden shrine", "watchtower"]
        for _ in range(min(count, 4)):
            loc = random.choice(locations)
            objectives.append(f"Discover the {loc}")

    elif quest_type == "Dungeon":
        objectives.append("Enter the dungeon")
        objectives.append("Defeat the mini-bosses")
        objectives.append("Slay the final boss")

    else:
        objectives.append("Complete the objective")

    return objectives


def generate_quest(
    quest_type: Optional[str] = None,
    level: Optional[int] = None,
    zone: Optional[str] = None,
) -> Quest:
    """
    Generate a random quest.

    Args:
        quest_type: Specific quest type (random if None)
        level: Quest level (random if None)
        zone: Quest zone (random if None)

    Returns:
        Generated Quest object
    """
    from mmofakelog.data.zones import generate_zone

    if quest_type is None:
        quest_type = random.choice(QUEST_TYPES)

    if level is None:
        level = random.randint(1, MAX_PLAYER_LEVEL)

    if zone is None:
        zone = generate_zone(level=level)

    # Determine if this is elite/group content
    is_elite = quest_type in ("Dungeon", "Raid") or random.random() < 0.1
    is_group = is_elite or quest_type == "Raid"

    # Calculate rewards based on level and type
    base_xp = level * 100
    if is_elite:
        base_xp *= 2
    if quest_type == "Story":
        base_xp *= 3

    xp_reward = int(base_xp * random.uniform(0.8, 1.2))
    xp_reward = max(MIN_QUEST_XP, min(xp_reward, MAX_QUEST_XP))

    gold_reward = int(level * 10 * random.uniform(0.5, 1.5))

    return Quest(
        quest_id=random.randint(1000, 99999),
        name=generate_quest_name(quest_type, is_epic=(quest_type == "Story")),
        quest_type=quest_type,
        level=level,
        zone=zone,
        xp_reward=xp_reward,
        gold_reward=gold_reward,
        objectives=generate_objectives(quest_type),
        is_elite=is_elite,
        is_group=is_group,
    )


def generate_quest_chain(
    length: int = 5,
    starting_level: int = 10,
    zone: Optional[str] = None,
) -> List[Quest]:
    """
    Generate a quest chain.

    Args:
        length: Number of quests in chain
        starting_level: Level of first quest
        zone: Zone for the chain

    Returns:
        List of Quest objects forming a chain
    """
    from mmofakelog.data.zones import generate_zone

    if zone is None:
        zone = generate_zone(level=starting_level)

    chain = []
    for i in range(length):
        quest = generate_quest(
            level=starting_level + i,
            zone=zone,
        )
        quest.chain_position = i + 1

        # Last quest in chain is often epic
        if i == length - 1:
            quest.name = random.choice(STORY_QUESTS)
            quest.xp_reward = int(quest.xp_reward * 2)
            quest.gold_reward = int(quest.gold_reward * 2)

        chain.append(quest)

    return chain
