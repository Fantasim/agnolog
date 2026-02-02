"""
Name generators for players, NPCs, guilds, and other entities.

Generates realistic MMORPG-style names without external dependencies.
"""

import random
import string
from typing import Optional

# =============================================================================
# NAME COMPONENTS
# =============================================================================

# Fantasy name prefixes
NAME_PREFIXES = (
    "Aer", "Bal", "Cor", "Dra", "Eld", "Fae", "Gor", "Hel", "Ire", "Jax",
    "Kel", "Lor", "Mor", "Nyx", "Ori", "Pyr", "Quin", "Rav", "Sor", "Thal",
    "Umb", "Val", "Wyr", "Xan", "Yar", "Zeph", "Ash", "Blaz", "Cyn", "Dusk",
    "Ech", "Frost", "Glim", "Hawk", "Iron", "Jade", "Krag", "Luna", "Mist",
    "Night", "Oak", "Storm", "Shadow", "Silver", "Thunder", "Void", "Wolf",
)

# Fantasy name suffixes
NAME_SUFFIXES = (
    "ion", "ius", "ara", "ora", "iel", "ael", "wen", "wyn", "mir", "dir",
    "las", "ras", "dor", "thor", "gar", "kar", "rin", "lin", "eth", "oth",
    "ix", "ax", "us", "is", "os", "an", "en", "in", "on", "un",
    "fire", "blade", "heart", "soul", "bane", "born", "wing", "claw",
)

# Common fantasy name roots
NAME_ROOTS = (
    "Dragon", "Shadow", "Storm", "Fire", "Ice", "Dark", "Light", "Night",
    "Blood", "Death", "Soul", "Spirit", "Thunder", "Wolf", "Raven", "Eagle",
    "Phoenix", "Demon", "Angel", "Chaos", "Order", "War", "Peace", "Doom",
    "Frost", "Flame", "Stone", "Steel", "Iron", "Silver", "Gold", "Crystal",
)

# Gamer-style name patterns
GAMER_ADJECTIVES = (
    "Epic", "Pro", "Elite", "Ultra", "Mega", "Super", "Hyper", "Neo",
    "Dark", "Shadow", "Silent", "Deadly", "Swift", "Fierce", "Savage",
    "Crazy", "Mad", "Wild", "Lone", "Noble", "Royal", "Ancient",
)

GAMER_NOUNS = (
    "Slayer", "Killer", "Hunter", "Sniper", "Ninja", "Samurai", "Knight",
    "Warrior", "Mage", "Wizard", "Archer", "Assassin", "Reaper", "Demon",
    "Dragon", "Wolf", "Tiger", "Lion", "Eagle", "Hawk", "Phoenix", "Raven",
    "Blade", "Sword", "Shield", "Hammer", "Axe", "Bow", "Staff", "Wand",
)

# Guild name components
GUILD_PREFIXES = (
    "Order of", "Knights of", "Brotherhood of", "Legion of", "Council of",
    "Circle of", "Guild of", "House of", "Clan of", "Alliance of",
    "The", "Ancient", "Eternal", "Sacred", "Divine", "Mystic", "Royal",
)

GUILD_NAMES = (
    "Phoenix", "Dragon", "Shadow", "Light", "Darkness", "Storm", "Fire",
    "Frost", "Thunder", "Iron", "Steel", "Silver", "Gold", "Crystal",
    "Crimson", "Azure", "Emerald", "Obsidian", "Valor", "Honor", "Glory",
    "Destiny", "Fate", "Fortune", "Vengeance", "Justice", "Mercy", "Wrath",
)

GUILD_SUFFIXES = (
    "Legion", "Order", "Brotherhood", "Alliance", "Covenant", "Crusade",
    "Guard", "Watch", "Sentinels", "Defenders", "Champions", "Warriors",
    "Knights", "Hunters", "Seekers", "Walkers", "Riders", "Lords", "Masters",
)

# NPC name components
NPC_TITLES = (
    "Merchant", "Innkeeper", "Blacksmith", "Armorer", "Weaponsmith",
    "Alchemist", "Herbalist", "Enchanter", "Jeweler", "Tailor",
    "Guard Captain", "Commander", "General", "Lord", "Lady",
    "Elder", "Sage", "Seer", "Oracle", "High Priest", "Priestess",
)

NPC_FIRST_NAMES = (
    "Aldric", "Bertram", "Cedric", "Duncan", "Edmund", "Frederick",
    "Geoffrey", "Harold", "Ignatius", "Jasper", "Kenneth", "Leopold",
    "Magnus", "Norbert", "Oswald", "Percival", "Quentin", "Reginald",
    "Helena", "Isabella", "Josephine", "Katherine", "Lucinda", "Margaret",
    "Nathaniel", "Ophelia", "Penelope", "Rosalind", "Seraphina", "Theodora",
)

# Fallback chat messages for various channels
CHAT_MESSAGES = {
    "say": [
        "Hello!", "Hi there!", "Anyone around?", "Nice weather today.",
        "Looking for a group!", "LFG!", "Anyone want to party up?",
        "Thanks!", "Good fight!", "GG", "Well played!",
        "Where's the nearest vendor?", "How do I get to the city?",
        "brb", "back", "afk", "gtg", "cya later!",
    ],
    "yell": [
        "HELP!", "INCOMING!", "RUN!", "BOSS INCOMING!",
        "VICTORY!", "WE DID IT!", "AMAZING!",
        "WORLD BOSS SPAWNED!", "RARE SPAWN UP!",
    ],
    "party": [
        "Ready?", "Let's go!", "Follow me", "Wait up",
        "Need heals", "Out of mana", "Low HP", "Pulling now",
        "CC that mob", "Focus the boss", "Stack up", "Spread out",
        "Nice loot!", "Grats!", "Good job team!",
    ],
    "guild": [
        "Hey guildies!", "Anyone online?", "Need help with a quest",
        "Raid tonight?", "What time is the event?", "Grats on the level!",
        "Welcome new member!", "Guild bank updated",
        "Looking for dungeon group", "Anyone want to PvP?",
    ],
    "trade": [
        "WTS [Epic Sword] 500g", "WTB [Health Potion] x20",
        "Selling crafting mats!", "Buying rare recipes",
        "LF Blacksmith for crafting", "Enchanter available for tips",
        "Price check on [Legendary Helm]?", "Best offer wins!",
    ],
    "whisper": [
        "Hey, got a sec?", "Thanks for the group!",
        "Want to trade?", "Nice gear!",
        "Are you in a guild?", "Good game earlier!",
    ],
}


# =============================================================================
# NAME GENERATORS
# =============================================================================


def generate_player_name() -> str:
    """
    Generate a random player username.

    Returns:
        A username like "DragonSlayer42" or "ShadowMage"
    """
    pattern = random.choice([
        "adjective_noun",
        "adjective_noun_num",
        "prefix_suffix",
        "root_suffix",
        "root_num",
    ])

    if pattern == "adjective_noun":
        return random.choice(GAMER_ADJECTIVES) + random.choice(GAMER_NOUNS)
    elif pattern == "adjective_noun_num":
        return (
            random.choice(GAMER_ADJECTIVES)
            + random.choice(GAMER_NOUNS)
            + str(random.randint(1, 999))
        )
    elif pattern == "prefix_suffix":
        return random.choice(NAME_PREFIXES) + random.choice(NAME_SUFFIXES)
    elif pattern == "root_suffix":
        return random.choice(NAME_ROOTS) + random.choice(NAME_SUFFIXES)
    else:  # root_num
        return random.choice(NAME_ROOTS) + str(random.randint(1, 99))


def generate_character_name() -> str:
    """
    Generate a fantasy character name.

    Returns:
        A name like "Thalion" or "Aelindra"
    """
    return random.choice(NAME_PREFIXES) + random.choice(NAME_SUFFIXES)


def generate_npc_name(with_title: bool = False) -> str:
    """
    Generate an NPC name.

    Args:
        with_title: Whether to include a title/profession

    Returns:
        A name like "Aldric" or "Blacksmith Magnus"
    """
    name = random.choice(NPC_FIRST_NAMES)
    if with_title:
        title = random.choice(NPC_TITLES)
        return f"{title} {name}"
    return name


def generate_guild_name() -> str:
    """
    Generate a guild name.

    Returns:
        A name like "Order of the Phoenix" or "Crimson Legion"
    """
    pattern = random.choice([
        "prefix_name",
        "name_suffix",
        "full",
    ])

    if pattern == "prefix_name":
        return f"{random.choice(GUILD_PREFIXES)} {random.choice(GUILD_NAMES)}"
    elif pattern == "name_suffix":
        return f"{random.choice(GUILD_NAMES)} {random.choice(GUILD_SUFFIXES)}"
    else:
        return (
            f"{random.choice(GUILD_PREFIXES)} {random.choice(GUILD_NAMES)} "
            f"{random.choice(GUILD_SUFFIXES)}"
        )


def generate_ip_address(internal: bool = False) -> str:
    """
    Generate a random IP address.

    Args:
        internal: Whether to generate an internal/private IP

    Returns:
        An IP address string
    """
    if internal:
        # Private IP ranges
        prefix = random.choice(["192.168", "10.0", "172.16"])
        if prefix == "192.168":
            return f"192.168.{random.randint(0, 255)}.{random.randint(1, 254)}"
        elif prefix == "10.0":
            return f"10.{random.randint(0, 255)}.{random.randint(0, 255)}.{random.randint(1, 254)}"
        else:
            return f"172.{random.randint(16, 31)}.{random.randint(0, 255)}.{random.randint(1, 254)}"
    else:
        # Public IP (avoiding reserved ranges)
        first = random.choice([
            random.randint(1, 9),
            random.randint(11, 126),
            random.randint(128, 191),
            random.randint(192, 223),
        ])
        return f"{first}.{random.randint(0, 255)}.{random.randint(0, 255)}.{random.randint(1, 254)}"


def generate_session_id(length: int = 16) -> str:
    """
    Generate a random session ID.

    Args:
        length: Length of the random portion

    Returns:
        A session ID like "sess_a1b2c3d4e5f6"
    """
    chars = string.ascii_lowercase + string.digits
    random_part = "".join(random.choice(chars) for _ in range(length))
    return f"sess_{random_part}"


def generate_account_id() -> str:
    """
    Generate a random account ID.

    Returns:
        An account ID like "ACC123456789"
    """
    return f"ACC{random.randint(100000000, 999999999)}"


def generate_character_id() -> int:
    """
    Generate a random character ID.

    Returns:
        A character ID (large integer)
    """
    return random.randint(10000000, 99999999)


def get_chat_message(channel: str) -> str:
    """
    Get a random chat message for a channel.

    Args:
        channel: Chat channel name

    Returns:
        A random message appropriate for the channel
    """
    messages = CHAT_MESSAGES.get(channel, CHAT_MESSAGES["say"])
    return random.choice(messages)
