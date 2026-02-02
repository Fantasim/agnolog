"""
Response caching for AI-generated content.

Caches AI responses to reduce API calls and costs.
Uses TTL-based expiration and LRU eviction.
"""

import hashlib
import time
from collections import OrderedDict
from dataclasses import dataclass
from typing import Optional

from mmofakelog.core.constants import AI_CACHE_TTL
from mmofakelog.logging import get_internal_logger


@dataclass
class CacheEntry:
    """A cached response entry."""
    value: str
    timestamp: float
    hits: int = 0


class ResponseCache:
    """
    TTL-based cache for AI responses.

    Features:
    - Time-to-live expiration
    - LRU eviction when max size reached
    - Hit tracking for analytics
    - Thread-safe operations

    Usage:
        cache = ResponseCache(max_size=1000, ttl=3600)
        cache.set("key", "value")
        value = cache.get("key")  # Returns "value" or None if expired
    """

    def __init__(
        self,
        max_size: int = 1000,
        ttl: int = AI_CACHE_TTL,
        enabled: bool = True,
    ) -> None:
        """
        Initialize the cache.

        Args:
            max_size: Maximum number of entries
            ttl: Time-to-live in seconds
            enabled: Whether caching is enabled
        """
        self._max_size = max_size
        self._ttl = ttl
        self._enabled = enabled
        self._cache: OrderedDict[str, CacheEntry] = OrderedDict()
        self._logger = get_internal_logger()
        self._hits = 0
        self._misses = 0

    def _make_key(self, *args: str) -> str:
        """Create a cache key from arguments."""
        combined = "|".join(str(arg) for arg in args)
        return hashlib.md5(combined.encode()).hexdigest()

    def _is_expired(self, entry: CacheEntry) -> bool:
        """Check if an entry has expired."""
        return time.time() - entry.timestamp > self._ttl

    def _evict_if_needed(self) -> None:
        """Evict oldest entries if cache is full."""
        while len(self._cache) >= self._max_size:
            # Remove oldest (first) entry
            oldest_key = next(iter(self._cache))
            del self._cache[oldest_key]
            self._logger.debug(f"Cache evicted: {oldest_key}")

    def get(self, *key_parts: str) -> Optional[str]:
        """
        Get a cached value.

        Args:
            *key_parts: Parts to construct the key

        Returns:
            Cached value or None if not found/expired
        """
        if not self._enabled:
            return None

        key = self._make_key(*key_parts)

        if key not in self._cache:
            self._misses += 1
            return None

        entry = self._cache[key]

        if self._is_expired(entry):
            del self._cache[key]
            self._misses += 1
            return None

        # Move to end (most recently used)
        self._cache.move_to_end(key)
        entry.hits += 1
        self._hits += 1

        return entry.value

    def set(self, *key_parts: str, value: str) -> None:
        """
        Set a cached value.

        Args:
            *key_parts: Parts to construct the key
            value: Value to cache
        """
        if not self._enabled:
            return

        key = self._make_key(*key_parts)

        # Evict if needed before adding
        if key not in self._cache:
            self._evict_if_needed()

        self._cache[key] = CacheEntry(
            value=value,
            timestamp=time.time(),
        )

        # Move to end (most recently used)
        self._cache.move_to_end(key)

    def invalidate(self, *key_parts: str) -> bool:
        """
        Invalidate a cached entry.

        Args:
            *key_parts: Parts to construct the key

        Returns:
            True if entry was found and removed
        """
        key = self._make_key(*key_parts)
        if key in self._cache:
            del self._cache[key]
            return True
        return False

    def clear(self) -> None:
        """Clear all cached entries."""
        self._cache.clear()
        self._logger.debug("Cache cleared")

    def cleanup_expired(self) -> int:
        """
        Remove all expired entries.

        Returns:
            Number of entries removed
        """
        expired_keys = [
            key for key, entry in self._cache.items()
            if self._is_expired(entry)
        ]
        for key in expired_keys:
            del self._cache[key]

        if expired_keys:
            self._logger.debug(f"Cleaned up {len(expired_keys)} expired entries")

        return len(expired_keys)

    @property
    def size(self) -> int:
        """Get current cache size."""
        return len(self._cache)

    @property
    def hit_rate(self) -> float:
        """Get cache hit rate."""
        total = self._hits + self._misses
        if total == 0:
            return 0.0
        return self._hits / total

    @property
    def stats(self) -> dict:
        """Get cache statistics."""
        return {
            "size": self.size,
            "max_size": self._max_size,
            "hits": self._hits,
            "misses": self._misses,
            "hit_rate": self.hit_rate,
            "ttl": self._ttl,
            "enabled": self._enabled,
        }

    def __contains__(self, key_parts: tuple) -> bool:
        """Check if key exists and is not expired."""
        return self.get(*key_parts) is not None

    def __len__(self) -> int:
        return self.size

    def __repr__(self) -> str:
        return (
            f"ResponseCache(size={self.size}, max_size={self._max_size}, "
            f"hit_rate={self.hit_rate:.2%})"
        )
