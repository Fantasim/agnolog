"""
AI prompt templates for content generation.

Contains carefully crafted prompts for generating realistic
MMORPG content using AI.
"""

from typing import Dict

# =============================================================================
# CHAT MESSAGE PROMPTS
# =============================================================================

CHAT_PROMPTS: Dict[str, str] = {
    "say": """Generate a single short casual chat message (1-10 words) that a player named {player_name} might say in local chat in an MMORPG. Context: {context}.
Rules:
- Use common MMORPG slang and abbreviations naturally
- Be casual and brief
- No quotation marks
- Just the message, nothing else""",

    "party": """Generate a single short party chat message (1-15 words) that a player named {player_name} might say during {context} in an MMORPG.
Rules:
- Focus on group coordination
- Use common gaming terms (aggro, pull, CC, DPS, heals, etc.)
- Be brief and actionable
- No quotation marks
- Just the message, nothing else""",

    "guild": """Generate a single guild chat message (1-20 words) that a player named {player_name} might say in their guild chat in an MMORPG. Context: {context}.
Rules:
- Be friendly and community-oriented
- Can discuss raids, events, or casual topics
- Use common guild terminology
- No quotation marks
- Just the message, nothing else""",

    "trade": """Generate a single trade chat message (5-20 words) that a player named {player_name} might post in trade chat in an MMORPG.
Rules:
- Use WTS (want to sell) or WTB (want to buy) format
- Include item names in brackets [Item Name]
- May include prices in gold (g)
- Be concise like a classified ad
- No quotation marks
- Just the message, nothing else""",

    "yell": """Generate a single CAPS or excited message (1-10 words) that a player named {player_name} might yell in an MMORPG during {context}.
Rules:
- All caps or very excited
- Usually about something dramatic happening
- Keep it short
- No quotation marks
- Just the message, nothing else""",

    "whisper": """Generate a single private whisper message (1-15 words) that a player might send to another player in an MMORPG. Context: {context}.
Rules:
- More personal/direct tone
- Could be asking for help, complimenting, or casual chat
- No quotation marks
- Just the message, nothing else""",
}

# =============================================================================
# QUEST PROMPTS
# =============================================================================

QUEST_PROMPTS: Dict[str, str] = {
    "name": """Generate a single fantasy quest name for a {quest_type} quest of {difficulty} difficulty.
Rules:
- Epic fantasy style
- 2-5 words
- No punctuation except apostrophes
- Just the name, nothing else""",

    "description": """Generate a brief quest description (1-2 sentences) for a {quest_type} quest called "{quest_name}" in a fantasy MMORPG.
Rules:
- Set in a fantasy world
- Mention the objective briefly
- Be dramatic but concise
- Just the description, nothing else""",

    "objective": """Generate a single quest objective line for a {quest_type} quest.
Rules:
- Start with an action verb
- Be specific (include numbers if kill/collect)
- 5-15 words
- Just the objective, nothing else""",
}

# =============================================================================
# EVENT PROMPTS
# =============================================================================

EVENT_PROMPTS: Dict[str, str] = {
    "world_event": """Generate a short announcement (1 sentence) for a world event starting in an MMORPG. Event type: {event_type}, Location: {location}.
Rules:
- Dramatic and exciting
- Include the location
- Urgent tone
- Just the announcement, nothing else""",

    "boss_spawn": """Generate a short server announcement (1 sentence) for a world boss spawning. Boss name: {boss_name}, Location: {location}.
Rules:
- Alert style message
- Include boss name and location
- Just the announcement, nothing else""",
}

# =============================================================================
# ITEM PROMPTS
# =============================================================================

ITEM_PROMPTS: Dict[str, str] = {
    "lore": """Generate a single sentence of item lore for a {rarity} {item_type} called "{item_name}" in a fantasy MMORPG.
Rules:
- Mysterious or epic tone appropriate to rarity
- Brief (1 sentence)
- Just the lore text, nothing else""",
}


# =============================================================================
# PROMPT GENERATORS
# =============================================================================


def generate_chat_prompt(
    channel: str,
    player_name: str,
    context: str = "casual gameplay",
) -> str:
    """
    Generate a chat message prompt.

    Args:
        channel: Chat channel (say, party, guild, etc.)
        player_name: Name of the speaker
        context: Situational context

    Returns:
        Formatted prompt string
    """
    template = CHAT_PROMPTS.get(channel, CHAT_PROMPTS["say"])
    return template.format(
        player_name=player_name,
        context=context,
    )


def generate_quest_prompt(
    prompt_type: str,
    quest_type: str = "kill",
    quest_name: str = "The Quest",
    difficulty: str = "normal",
) -> str:
    """
    Generate a quest-related prompt.

    Args:
        prompt_type: Type of prompt (name, description, objective)
        quest_type: Type of quest
        quest_name: Name of the quest
        difficulty: Quest difficulty

    Returns:
        Formatted prompt string
    """
    template = QUEST_PROMPTS.get(prompt_type, QUEST_PROMPTS["name"])
    return template.format(
        quest_type=quest_type,
        quest_name=quest_name,
        difficulty=difficulty,
    )


def generate_event_prompt(
    event_type: str,
    location: str = "Unknown",
    boss_name: str = "Unknown",
) -> str:
    """
    Generate an event announcement prompt.

    Args:
        event_type: Type of event or 'boss_spawn'
        location: Event location
        boss_name: Boss name (for boss_spawn)

    Returns:
        Formatted prompt string
    """
    if event_type == "boss_spawn":
        template = EVENT_PROMPTS["boss_spawn"]
        return template.format(boss_name=boss_name, location=location)
    else:
        template = EVENT_PROMPTS["world_event"]
        return template.format(event_type=event_type, location=location)


def generate_item_prompt(
    item_name: str,
    item_type: str,
    rarity: str,
) -> str:
    """
    Generate an item lore prompt.

    Args:
        item_name: Name of the item
        item_type: Type of item
        rarity: Item rarity

    Returns:
        Formatted prompt string
    """
    template = ITEM_PROMPTS["lore"]
    return template.format(
        item_name=item_name,
        item_type=item_type,
        rarity=rarity,
    )
