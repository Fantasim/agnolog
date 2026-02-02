"""
AI integration module for dynamic content generation.

Provides OpenAI-powered content generation for:
- Realistic chat messages
- Quest descriptions
- Item lore
- Dynamic event narratives

Usage:
    from mmofakelog.ai import AIClient

    client = AIClient()
    message = client.generate_chat_message(
        context="dungeon run",
        player_name="DragonSlayer",
        channel="party"
    )
"""

from mmofakelog.ai.client import AIClient, MockAIClient
from mmofakelog.ai.prompts import (
    CHAT_PROMPTS,
    QUEST_PROMPTS,
    generate_chat_prompt,
    generate_quest_prompt,
)
from mmofakelog.ai.cache import ResponseCache

__all__ = [
    "AIClient",
    "MockAIClient",
    "ResponseCache",
    "CHAT_PROMPTS",
    "QUEST_PROMPTS",
    "generate_chat_prompt",
    "generate_quest_prompt",
]
