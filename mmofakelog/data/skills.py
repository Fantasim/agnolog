"""
Skill and ability data for the fake log system.

Provides class-specific skills and ability generators.
"""

import random
from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple

from mmofakelog.core.constants import CHARACTER_CLASSES

# =============================================================================
# SKILL TYPE DEFINITIONS
# =============================================================================

SKILL_TYPES: Tuple[str, ...] = (
    "Attack", "Defense", "Heal", "Buff", "Debuff",
    "AoE", "DoT", "HoT", "CC", "Utility",
)

DAMAGE_TYPES: Tuple[str, ...] = (
    "Physical", "Fire", "Frost", "Arcane", "Nature", "Shadow", "Holy",
)

# =============================================================================
# CLASS-SPECIFIC SKILLS
# =============================================================================

SKILLS_BY_CLASS: Dict[str, Tuple[str, ...]] = {
    "Warrior": (
        "Heroic Strike", "Mortal Strike", "Execute", "Whirlwind",
        "Charge", "Intercept", "Shield Slam", "Devastate",
        "Thunder Clap", "Cleave", "Rend", "Overpower",
        "Battle Shout", "Commanding Shout", "Shield Wall", "Last Stand",
        "Berserker Rage", "Bloodthirst", "Rampage", "Victory Rush",
    ),
    "Paladin": (
        "Crusader Strike", "Templar's Verdict", "Divine Storm",
        "Hammer of Wrath", "Avenger's Shield", "Shield of the Righteous",
        "Flash of Light", "Holy Light", "Holy Shock", "Word of Glory",
        "Lay on Hands", "Divine Shield", "Blessing of Protection",
        "Consecration", "Judgment", "Exorcism", "Avenging Wrath",
    ),
    "Hunter": (
        "Aimed Shot", "Arcane Shot", "Multi-Shot", "Steady Shot",
        "Kill Shot", "Chimera Shot", "Black Arrow", "Explosive Shot",
        "Serpent Sting", "Concussive Shot", "Distracting Shot",
        "Freezing Trap", "Explosive Trap", "Aspect of the Hawk",
        "Rapid Fire", "Bestial Wrath", "Kill Command", "Cobra Shot",
    ),
    "Rogue": (
        "Sinister Strike", "Eviscerate", "Backstab", "Ambush",
        "Mutilate", "Envenom", "Rupture", "Garrote",
        "Slice and Dice", "Adrenaline Rush", "Blade Flurry",
        "Shadowstep", "Vanish", "Cloak of Shadows", "Evasion",
        "Kidney Shot", "Cheap Shot", "Blind", "Sap",
    ),
    "Priest": (
        "Smite", "Mind Blast", "Shadow Word: Pain", "Shadow Word: Death",
        "Mind Flay", "Vampiric Touch", "Devouring Plague",
        "Flash Heal", "Greater Heal", "Prayer of Healing", "Circle of Healing",
        "Power Word: Shield", "Renew", "Prayer of Mending",
        "Dispel Magic", "Mass Dispel", "Psychic Scream", "Fade",
    ),
    "Shaman": (
        "Lightning Bolt", "Chain Lightning", "Lava Burst", "Earth Shock",
        "Flame Shock", "Frost Shock", "Stormstrike", "Lava Lash",
        "Healing Wave", "Lesser Healing Wave", "Chain Heal", "Riptide",
        "Earth Shield", "Water Shield", "Lightning Shield",
        "Totemic Recall", "Fire Elemental", "Earth Elemental",
    ),
    "Mage": (
        "Fireball", "Frostbolt", "Arcane Blast", "Arcane Missiles",
        "Pyroblast", "Ice Lance", "Frostfire Bolt", "Living Bomb",
        "Blizzard", "Flamestrike", "Arcane Explosion", "Cone of Cold",
        "Fire Blast", "Frost Nova", "Blink", "Ice Block",
        "Mirror Image", "Combustion", "Icy Veins", "Arcane Power",
    ),
    "Warlock": (
        "Shadow Bolt", "Incinerate", "Chaos Bolt", "Soul Fire",
        "Immolate", "Corruption", "Unstable Affliction", "Curse of Agony",
        "Drain Life", "Drain Soul", "Haunt", "Shadowflame",
        "Rain of Fire", "Hellfire", "Seed of Corruption",
        "Fear", "Howl of Terror", "Death Coil", "Shadowfury",
    ),
    "Druid": (
        "Wrath", "Starfire", "Moonfire", "Insect Swarm",
        "Mangle", "Shred", "Rake", "Rip", "Ferocious Bite",
        "Maul", "Lacerate", "Swipe", "Thrash",
        "Rejuvenation", "Regrowth", "Lifebloom", "Wild Growth",
        "Nourish", "Healing Touch", "Tranquility", "Barkskin",
    ),
    "Death Knight": (
        "Icy Touch", "Plague Strike", "Blood Strike", "Heart Strike",
        "Obliterate", "Frost Strike", "Howling Blast", "Death Strike",
        "Death and Decay", "Blood Boil", "Pestilence",
        "Death Grip", "Chains of Ice", "Strangulate", "Mind Freeze",
        "Anti-Magic Shell", "Icebound Fortitude", "Army of the Dead",
    ),
    "Monk": (
        "Jab", "Tiger Palm", "Blackout Kick", "Rising Sun Kick",
        "Fists of Fury", "Spinning Crane Kick", "Keg Smash", "Breath of Fire",
        "Soothing Mist", "Enveloping Mist", "Renewing Mist", "Uplift",
        "Roll", "Flying Serpent Kick", "Transcendence", "Touch of Death",
        "Fortifying Brew", "Zen Meditation", "Life Cocoon",
    ),
    "Demon Hunter": (
        "Demon's Bite", "Chaos Strike", "Blade Dance", "Eye Beam",
        "Fel Rush", "Vengeful Retreat", "Metamorphosis",
        "Throw Glaive", "Immolation Aura", "Soul Cleave", "Sigil of Flame",
        "Fiery Brand", "Demon Spikes", "Darkness",
        "Spectral Sight", "Consume Magic", "Imprison",
    ),
}

# Generic skills for any class
GENERIC_SKILLS: Tuple[str, ...] = (
    "Auto Attack", "Sprint", "Mount", "Hearthstone",
    "Bandage", "Use Item", "Interact", "Trade",
)

# =============================================================================
# SKILL DATA STRUCTURE
# =============================================================================


@dataclass
class Skill:
    """Represents a character skill/ability."""
    skill_id: int
    name: str
    skill_type: str
    damage_type: Optional[str]
    cooldown: float  # seconds
    cast_time: float  # seconds
    mana_cost: int
    min_damage: int
    max_damage: int
    level_required: int

    def __str__(self) -> str:
        return self.name


# =============================================================================
# SKILL GENERATORS
# =============================================================================


def get_skills_for_class(character_class: str) -> List[str]:
    """
    Get all skills for a character class.

    Args:
        character_class: The class name

    Returns:
        List of skill names
    """
    class_skills = SKILLS_BY_CLASS.get(character_class, ())
    return list(class_skills) + list(GENERIC_SKILLS)


def generate_skill(
    character_class: Optional[str] = None,
    skill_name: Optional[str] = None,
) -> Skill:
    """
    Generate a skill.

    Args:
        character_class: Optionally filter by class
        skill_name: Specific skill name (random if None)

    Returns:
        Generated Skill object
    """
    if skill_name is None:
        if character_class:
            skills = get_skills_for_class(character_class)
        else:
            all_skills: List[str] = list(GENERIC_SKILLS)
            for class_skills in SKILLS_BY_CLASS.values():
                all_skills.extend(class_skills)
            skills = all_skills
        skill_name = random.choice(skills)

    # Determine skill type from name patterns
    skill_type = "Attack"
    if any(word in skill_name.lower() for word in ["heal", "mend", "rejuv", "renew"]):
        skill_type = "Heal"
    elif any(word in skill_name.lower() for word in ["shield", "protect", "fortify"]):
        skill_type = "Defense"
    elif any(word in skill_name.lower() for word in ["buff", "blessing", "shout"]):
        skill_type = "Buff"
    elif any(word in skill_name.lower() for word in ["curse", "plague", "weaken"]):
        skill_type = "Debuff"

    # Determine damage type from name patterns
    damage_type: Optional[str] = None
    if skill_type in ("Attack", "DoT", "AoE"):
        if any(word in skill_name.lower() for word in ["fire", "flame", "burn", "pyro"]):
            damage_type = "Fire"
        elif any(word in skill_name.lower() for word in ["frost", "ice", "cold", "freeze"]):
            damage_type = "Frost"
        elif any(word in skill_name.lower() for word in ["shadow", "dark", "void"]):
            damage_type = "Shadow"
        elif any(word in skill_name.lower() for word in ["holy", "light", "divine"]):
            damage_type = "Holy"
        elif any(word in skill_name.lower() for word in ["arcane", "magic"]):
            damage_type = "Arcane"
        elif any(word in skill_name.lower() for word in ["nature", "earth", "storm"]):
            damage_type = "Nature"
        else:
            damage_type = "Physical"

    return Skill(
        skill_id=random.randint(1000, 99999),
        name=skill_name,
        skill_type=skill_type,
        damage_type=damage_type,
        cooldown=random.choice([0, 3, 6, 8, 10, 15, 30, 60, 120]),
        cast_time=random.choice([0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0]),
        mana_cost=random.randint(0, 500),
        min_damage=random.randint(100, 1000),
        max_damage=random.randint(1000, 5000),
        level_required=random.randint(1, 60),
    )


def generate_random_skill_for_class(character_class: str) -> str:
    """
    Generate a random skill name for a class.

    Args:
        character_class: The class name

    Returns:
        Random skill name
    """
    skills = SKILLS_BY_CLASS.get(character_class, GENERIC_SKILLS)
    return random.choice(skills)
