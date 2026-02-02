"""
Item data and generators for the fake log system.

Generates realistic MMORPG items with names, stats, and rarities.
"""

import random
from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple

from mmofakelog.core.constants import (
    ITEM_RARITIES,
    MAX_ITEM_STACK,
    MAX_PLAYER_LEVEL,
    MAX_VENDOR_PRICE,
    MIN_VENDOR_PRICE,
    RARITY_WEIGHTS,
)

# =============================================================================
# ITEM TYPE DEFINITIONS
# =============================================================================

WEAPON_TYPES: Tuple[str, ...] = (
    "Sword", "Axe", "Mace", "Dagger", "Staff", "Wand",
    "Bow", "Crossbow", "Gun", "Polearm", "Fist Weapon",
    "Two-Handed Sword", "Two-Handed Axe", "Two-Handed Mace",
)

ARMOR_TYPES: Tuple[str, ...] = (
    "Cloth Helm", "Cloth Chest", "Cloth Legs", "Cloth Gloves", "Cloth Boots",
    "Leather Helm", "Leather Chest", "Leather Legs", "Leather Gloves", "Leather Boots",
    "Mail Helm", "Mail Chest", "Mail Legs", "Mail Gloves", "Mail Boots",
    "Plate Helm", "Plate Chest", "Plate Legs", "Plate Gloves", "Plate Boots",
    "Shield", "Cloak", "Belt", "Bracers",
)

ACCESSORY_TYPES: Tuple[str, ...] = (
    "Ring", "Necklace", "Trinket", "Earring", "Relic",
)

CONSUMABLE_TYPES: Tuple[str, ...] = (
    "Health Potion", "Mana Potion", "Elixir", "Flask",
    "Food", "Drink", "Bandage", "Scroll", "Rune",
)

MATERIAL_TYPES: Tuple[str, ...] = (
    "Ore", "Herb", "Leather", "Cloth", "Gem",
    "Essence", "Dust", "Shard", "Crystal", "Ingot",
)

ITEM_TYPES: Tuple[str, ...] = (
    WEAPON_TYPES + ARMOR_TYPES + ACCESSORY_TYPES + CONSUMABLE_TYPES + MATERIAL_TYPES
)

# =============================================================================
# ITEM NAME COMPONENTS
# =============================================================================

ITEM_PREFIXES: Dict[str, Tuple[str, ...]] = {
    "Common": ("Worn", "Old", "Simple", "Basic", "Plain"),
    "Uncommon": ("Fine", "Sturdy", "Solid", "Tempered", "Crafted"),
    "Rare": ("Superior", "Exceptional", "Masterwork", "Enchanted", "Blessed"),
    "Epic": ("Heroic", "Legendary", "Ancient", "Mythical", "Divine"),
    "Legendary": ("Godforged", "Eternal", "Celestial", "Primordial", "Worldbreaker"),
}

ITEM_SUFFIXES: Dict[str, Tuple[str, ...]] = {
    "weapon": (
        "of Strength", "of Agility", "of Power", "of the Bear",
        "of the Tiger", "of the Eagle", "of Slaying", "of Destruction",
        "of the Phoenix", "of Thunder", "of Frost", "of Flames",
    ),
    "armor": (
        "of Defense", "of Protection", "of the Turtle", "of Fortitude",
        "of the Sentinel", "of Warding", "of the Guardian", "of Resilience",
        "of the Mountain", "of Iron Will", "of Vitality", "of Endurance",
    ),
    "accessory": (
        "of Wisdom", "of Intelligence", "of Spirit", "of the Owl",
        "of Clarity", "of Focus", "of Insight", "of the Sage",
        "of Magic", "of the Arcane", "of Mysticism", "of Sorcery",
    ),
}

WEAPON_NAMES: Tuple[str, ...] = (
    "Blade", "Edge", "Fang", "Claw", "Talon", "Sting",
    "Cleaver", "Render", "Splitter", "Crusher", "Smasher",
    "Whisper", "Shadow", "Storm", "Thunder", "Lightning",
    "Fury", "Rage", "Wrath", "Vengeance", "Justice",
)

ARMOR_NAMES: Tuple[str, ...] = (
    "Aegis", "Bulwark", "Bastion", "Rampart", "Fortress",
    "Mantle", "Shroud", "Veil", "Cloak", "Ward",
    "Shell", "Carapace", "Hide", "Skin", "Scale",
)

# =============================================================================
# ITEM DATA STRUCTURE
# =============================================================================


@dataclass
class Item:
    """Represents a game item."""
    item_id: int
    name: str
    item_type: str
    rarity: str
    level: int
    value: int
    stackable: bool
    max_stack: int
    bound: bool

    def __str__(self) -> str:
        return f"[{self.rarity}] {self.name}"


# =============================================================================
# ITEM GENERATORS
# =============================================================================


def _select_rarity() -> str:
    """Select a random rarity based on weights."""
    rarities = list(RARITY_WEIGHTS.keys())
    weights = list(RARITY_WEIGHTS.values())
    return random.choices(rarities, weights=weights, k=1)[0]


def _get_item_category(item_type: str) -> str:
    """Determine the category of an item type."""
    if item_type in WEAPON_TYPES:
        return "weapon"
    elif item_type in ARMOR_TYPES:
        return "armor"
    elif item_type in ACCESSORY_TYPES:
        return "accessory"
    elif item_type in CONSUMABLE_TYPES:
        return "consumable"
    else:
        return "material"


def generate_item_name(
    item_type: str,
    rarity: str,
    include_suffix: bool = True,
) -> str:
    """
    Generate a name for an item.

    Args:
        item_type: Type of item (Sword, Plate Helm, etc.)
        rarity: Rarity level
        include_suffix: Whether to add a suffix

    Returns:
        Generated item name
    """
    category = _get_item_category(item_type)

    # Get prefix based on rarity
    prefixes = ITEM_PREFIXES.get(rarity, ITEM_PREFIXES["Common"])
    prefix = random.choice(prefixes)

    # Build base name
    if category == "weapon":
        base_name = f"{prefix} {item_type}"
        if rarity in ("Epic", "Legendary") and random.random() < 0.5:
            base_name = f"{random.choice(WEAPON_NAMES)}, {prefix} {item_type}"
    elif category in ("armor", "accessory"):
        base_name = f"{prefix} {item_type}"
    else:
        base_name = f"{prefix} {item_type}"

    # Add suffix for higher rarities
    if include_suffix and rarity in ("Rare", "Epic", "Legendary"):
        suffixes = ITEM_SUFFIXES.get(category, ITEM_SUFFIXES["weapon"])
        suffix = random.choice(suffixes)
        base_name = f"{base_name} {suffix}"

    return base_name


def generate_item(
    item_type: Optional[str] = None,
    rarity: Optional[str] = None,
    level: Optional[int] = None,
) -> Item:
    """
    Generate a random item.

    Args:
        item_type: Specific item type (random if None)
        rarity: Specific rarity (random if None)
        level: Specific level (random if None)

    Returns:
        Generated Item object
    """
    # Select type, rarity, level
    if item_type is None:
        item_type = random.choice(ITEM_TYPES)

    if rarity is None:
        rarity = _select_rarity()

    if level is None:
        level = random.randint(1, MAX_PLAYER_LEVEL)

    category = _get_item_category(item_type)

    # Determine item properties based on category
    if category in ("consumable", "material"):
        stackable = True
        max_stack = random.choice([5, 10, 20, 50, 100, 200])
        bound = False
    else:
        stackable = False
        max_stack = 1
        bound = rarity in ("Epic", "Legendary") or random.random() < 0.3

    # Calculate value based on rarity and level
    rarity_multipliers = {
        "Poor": 0.1,
        "Common": 1.0,
        "Uncommon": 3.0,
        "Rare": 10.0,
        "Epic": 50.0,
        "Legendary": 500.0,
        "Artifact": 5000.0,
    }
    multiplier = rarity_multipliers.get(rarity, 1.0)
    base_value = level * 10
    value = int(base_value * multiplier * random.uniform(0.8, 1.2))
    value = max(MIN_VENDOR_PRICE, min(value, MAX_VENDOR_PRICE))

    return Item(
        item_id=random.randint(10000, 99999),
        name=generate_item_name(item_type, rarity),
        item_type=item_type,
        rarity=rarity,
        level=level,
        value=value,
        stackable=stackable,
        max_stack=max_stack,
        bound=bound,
    )


def generate_loot_drop(
    mob_level: int,
    is_boss: bool = False,
    loot_count: int = 1,
) -> List[Item]:
    """
    Generate loot drops from a monster.

    Args:
        mob_level: Level of the monster
        is_boss: Whether this is a boss (better loot)
        loot_count: Number of items to drop

    Returns:
        List of Item objects
    """
    items = []

    for _ in range(loot_count):
        # Boss has better rarity chances
        if is_boss:
            rarity = random.choices(
                ["Uncommon", "Rare", "Epic", "Legendary"],
                weights=[0.3, 0.4, 0.25, 0.05],
                k=1,
            )[0]
        else:
            rarity = _select_rarity()

        # Item level is around mob level
        item_level = max(1, mob_level + random.randint(-2, 2))

        items.append(generate_item(rarity=rarity, level=item_level))

    return items


def generate_gold_drop(mob_level: int, is_boss: bool = False) -> int:
    """
    Generate gold dropped by a monster.

    Args:
        mob_level: Level of the monster
        is_boss: Whether this is a boss

    Returns:
        Gold amount
    """
    base = mob_level * 5
    if is_boss:
        base *= 10

    return int(base * random.uniform(0.5, 1.5))
