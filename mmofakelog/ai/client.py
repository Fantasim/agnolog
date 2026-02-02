"""
AI client for OpenAI integration.

Provides AI-powered content generation with:
- Automatic retry with exponential backoff
- Response caching
- Fallback to static content
- Rate limiting awareness
"""

import os
import time
from typing import Optional

from mmofakelog.ai.cache import ResponseCache
from mmofakelog.ai.prompts import generate_chat_prompt, generate_quest_prompt
from mmofakelog.core.constants import (
    AI_MAX_RETRIES,
    AI_MAX_TOKENS,
    AI_REQUEST_TIMEOUT,
    AI_RETRY_DELAY,
    AI_TEMPERATURE,
    DEFAULT_AI_MODEL,
)
from mmofakelog.core.errors import (
    AIConfigurationError,
    AIConnectionError,
    AIRateLimitError,
    AIResponseError,
)
from mmofakelog.data.names import get_chat_message
from mmofakelog.logging import InternalLoggerMixin


class AIClient(InternalLoggerMixin):
    """
    OpenAI-powered content generator for realistic MMORPG content.

    Features:
    - Automatic fallback when API unavailable
    - Response caching to minimize API calls
    - Retry logic with exponential backoff
    - Rate limit handling

    Usage:
        client = AIClient()
        message = client.generate_chat_message(
            context="dungeon run",
            player_name="DragonSlayer",
            channel="party"
        )
    """

    def __init__(
        self,
        api_key: Optional[str] = None,
        model: str = DEFAULT_AI_MODEL,
        cache_enabled: bool = True,
        cache_ttl: int = 3600,
    ) -> None:
        """
        Initialize the AI client.

        Args:
            api_key: OpenAI API key (uses env var if None)
            model: Model to use for generation
            cache_enabled: Whether to cache responses
            cache_ttl: Cache time-to-live in seconds
        """
        self._api_key = api_key or os.environ.get("OPENAI_API_KEY")
        self._model = model
        self._client = None
        self._cache = ResponseCache(enabled=cache_enabled, ttl=cache_ttl)

        # Initialize OpenAI client if API key available
        if self._api_key:
            try:
                import openai
                self._client = openai.OpenAI(
                    api_key=self._api_key,
                    timeout=AI_REQUEST_TIMEOUT,
                )
                self._log_info(f"OpenAI client initialized with model: {model}")
            except ImportError:
                self._log_warning("OpenAI package not installed, using fallback mode")
            except Exception as e:
                self._log_warning(f"Failed to initialize OpenAI client: {e}")
        else:
            self._log_info("No API key provided, using fallback mode")

    @property
    def is_available(self) -> bool:
        """Check if AI generation is available."""
        return self._client is not None

    def _call_api(self, prompt: str, max_tokens: int = AI_MAX_TOKENS) -> str:
        """
        Make an API call with retry logic.

        Args:
            prompt: The prompt to send
            max_tokens: Maximum tokens in response

        Returns:
            Generated text

        Raises:
            AIConnectionError: If connection fails
            AIRateLimitError: If rate limited
            AIResponseError: If response is invalid
        """
        if self._client is None:
            raise AIConfigurationError("OpenAI client not initialized")

        import openai

        last_error = None

        for attempt in range(AI_MAX_RETRIES):
            try:
                response = self._client.chat.completions.create(
                    model=self._model,
                    messages=[{"role": "user", "content": prompt}],
                    max_tokens=max_tokens,
                    temperature=AI_TEMPERATURE,
                )

                if response.choices and response.choices[0].message.content:
                    return response.choices[0].message.content.strip()
                else:
                    raise AIResponseError("Empty response from API")

            except openai.RateLimitError as e:
                retry_after = getattr(e, "retry_after", 60)
                self._log_warning(f"Rate limited, retry after {retry_after}s")
                raise AIRateLimitError(retry_after=retry_after)

            except openai.APIConnectionError as e:
                last_error = e
                self._log_warning(f"Connection error (attempt {attempt + 1}): {e}")
                time.sleep(AI_RETRY_DELAY * (2 ** attempt))

            except openai.APIStatusError as e:
                last_error = e
                self._log_error(f"API error: {e}")
                raise AIConnectionError("OpenAI", str(e))

            except Exception as e:
                last_error = e
                self._log_error(f"Unexpected error: {e}")
                raise AIResponseError(str(e))

        raise AIConnectionError("OpenAI", f"Max retries exceeded: {last_error}")

    def generate_chat_message(
        self,
        context: str,
        player_name: str,
        channel: str,
        use_cache: bool = True,
    ) -> str:
        """
        Generate a realistic chat message.

        Args:
            context: Situational context (e.g., "dungeon run", "pvp battle")
            player_name: Name of the speaker
            channel: Chat channel (say, party, guild, etc.)
            use_cache: Whether to use cached responses

        Returns:
            Generated chat message
        """
        # Check cache first
        if use_cache:
            cached = self._cache.get("chat", channel, context)
            if cached:
                self._log_debug(f"Cache hit for chat:{channel}")
                return cached

        # Try AI generation
        if self._client:
            try:
                prompt = generate_chat_prompt(channel, player_name, context)
                message = self._call_api(prompt, max_tokens=50)

                # Cache the result
                if use_cache:
                    self._cache.set("chat", channel, context, value=message)

                return message

            except (AIRateLimitError, AIConnectionError, AIResponseError) as e:
                self._log_warning(f"AI generation failed, using fallback: {e}")

        # Fallback to static messages
        return get_chat_message(channel)

    def generate_quest_text(
        self,
        quest_type: str,
        difficulty: str = "normal",
        text_type: str = "name",
    ) -> str:
        """
        Generate quest-related text.

        Args:
            quest_type: Type of quest (kill, collect, escort, etc.)
            difficulty: Quest difficulty
            text_type: What to generate (name, description, objective)

        Returns:
            Generated text
        """
        # Check cache
        cached = self._cache.get("quest", quest_type, text_type)
        if cached:
            return cached

        # Try AI generation
        if self._client:
            try:
                prompt = generate_quest_prompt(text_type, quest_type, difficulty=difficulty)
                text = self._call_api(prompt, max_tokens=100)
                self._cache.set("quest", quest_type, text_type, value=text)
                return text
            except Exception as e:
                self._log_warning(f"Quest text generation failed: {e}")

        # Fallback
        from mmofakelog.data.quests import generate_quest_name
        return generate_quest_name(quest_type)

    def generate_item_description(
        self,
        item_type: str,
        rarity: str,
        item_name: str = "Unknown Item",
    ) -> str:
        """
        Generate item lore/description.

        Args:
            item_type: Type of item
            rarity: Item rarity
            item_name: Name of the item

        Returns:
            Generated lore text
        """
        from mmofakelog.ai.prompts import generate_item_prompt

        # Check cache
        cached = self._cache.get("item", item_type, rarity)
        if cached:
            return cached

        if self._client:
            try:
                prompt = generate_item_prompt(item_name, item_type, rarity)
                text = self._call_api(prompt, max_tokens=100)
                self._cache.set("item", item_type, rarity, value=text)
                return text
            except Exception as e:
                self._log_warning(f"Item description generation failed: {e}")

        # Fallback - simple generated lore
        return f"A {rarity.lower()} {item_type.lower()} of unknown origin."

    def get_cache_stats(self) -> dict:
        """Get cache statistics."""
        return self._cache.stats

    def clear_cache(self) -> None:
        """Clear the response cache."""
        self._cache.clear()

    def __repr__(self) -> str:
        status = "available" if self.is_available else "fallback"
        return f"AIClient(model={self._model}, status={status})"


class MockAIClient:
    """
    Mock AI client for testing.

    Provides predictable responses without API calls.
    """

    def __init__(self, responses: Optional[dict] = None) -> None:
        """
        Initialize mock client.

        Args:
            responses: Dict mapping keys to response values
        """
        self._responses = responses or {}

    @property
    def is_available(self) -> bool:
        return True

    def generate_chat_message(
        self,
        context: str,
        player_name: str,
        channel: str,
        use_cache: bool = True,
    ) -> str:
        key = f"chat:{channel}"
        if key in self._responses:
            return self._responses[key]
        return f"[{player_name}]: Test message for {channel}"

    def generate_quest_text(
        self,
        quest_type: str,
        difficulty: str = "normal",
        text_type: str = "name",
    ) -> str:
        key = f"quest:{text_type}"
        if key in self._responses:
            return self._responses[key]
        return f"Test {quest_type} Quest"

    def generate_item_description(
        self,
        item_type: str,
        rarity: str,
        item_name: str = "Unknown Item",
    ) -> str:
        key = f"item:{rarity}"
        if key in self._responses:
            return self._responses[key]
        return f"A test {rarity} {item_type}."

    def get_cache_stats(self) -> dict:
        return {"mock": True}

    def clear_cache(self) -> None:
        pass

    def __repr__(self) -> str:
        return "MockAIClient()"
