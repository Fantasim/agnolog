"""
Pytest fixtures and configuration for mmofakelog tests.
"""

import importlib
import pytest
from datetime import datetime, timedelta
from typing import Dict, Any, List

from mmofakelog.core.registry import LogTypeRegistry, register_log_type
from mmofakelog.core.types import (
    LogCategory,
    LogEntry,
    LogSeverity,
    LogTypeMetadata,
    RecurrencePattern,
)
from mmofakelog.generators.base import BaseLogGenerator


def _ensure_generators_registered():
    """Ensure all generators are registered in the registry.

    This is needed because after reset_registry() is called, the
    singleton is cleared but Python's module cache still has the
    generators imported. This function forces re-registration by
    reloading the generator modules.
    """
    registry = LogTypeRegistry()
    if registry.count() == 0:
        # Registry is empty, need to reload generators
        from mmofakelog.generators import player, server, security, economy, combat, technical
        importlib.reload(player)
        importlib.reload(server)
        importlib.reload(security)
        importlib.reload(economy)
        importlib.reload(combat)
        importlib.reload(technical)


# Ensure generators are registered at module load time
_ensure_generators_registered()


@pytest.fixture
def reset_registry():
    """Reset the registry before and after each test."""
    LogTypeRegistry.reset()
    yield
    LogTypeRegistry.reset()


@pytest.fixture
def empty_registry(reset_registry):
    """Provide a fresh empty registry."""
    return LogTypeRegistry()


@pytest.fixture
def sample_timestamp():
    """Provide a fixed timestamp for testing."""
    return datetime(2024, 1, 15, 12, 30, 45, 123456)


@pytest.fixture
def sample_metadata():
    """Provide sample log type metadata."""
    return LogTypeMetadata(
        name="test.sample",
        category=LogCategory.PLAYER,
        severity=LogSeverity.INFO,
        recurrence=RecurrencePattern.NORMAL,
        description="Sample test log type",
        text_template="[{timestamp}] TEST: {message}",
        tags=("test", "sample"),
    )


@pytest.fixture
def sample_log_entry(sample_timestamp):
    """Provide a sample log entry for testing."""
    return LogEntry(
        log_type="player.login",
        timestamp=sample_timestamp,
        severity=LogSeverity.INFO,
        category=LogCategory.PLAYER,
        data={
            "username": "TestPlayer",
            "character_name": "DragonSlayer",
            "ip": "192.168.1.100",
            "level": 42,
            "zone": "Stormwind",
        },
        server_id="server-01",
        session_id="sess-12345",
    )


@pytest.fixture
def sample_log_entries(sample_timestamp):
    """Provide multiple sample log entries."""
    entries = []
    for i in range(5):
        entries.append(
            LogEntry(
                log_type=f"test.type{i}",
                timestamp=sample_timestamp + timedelta(seconds=i),
                severity=LogSeverity.INFO,
                category=LogCategory.PLAYER,
                data={"index": i, "message": f"Test message {i}"},
                server_id="server-01",
            )
        )
    return entries


class SampleGenerator(BaseLogGenerator):
    """Sample generator for testing."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "message": kwargs.get("message", "test message"),
            "value": kwargs.get("value", 42),
        }


@pytest.fixture
def sample_generator():
    """Provide a sample generator instance."""
    return SampleGenerator()


@pytest.fixture
def registered_sample_generator(empty_registry, sample_metadata):
    """Register and return a sample generator."""
    empty_registry.register(
        sample_metadata.name,
        sample_metadata,
        SampleGenerator,
    )
    return SampleGenerator()


@pytest.fixture
def populated_registry():
    """Provide the global registry with all log types registered.

    This fixture ensures all generators are registered, even if
    a previous test reset the registry. It uses importlib.reload
    to force re-registration of all generator modules.
    """
    _ensure_generators_registered()
    return LogTypeRegistry()
