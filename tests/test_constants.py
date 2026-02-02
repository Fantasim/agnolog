"""
Tests for mmofakelog.core.constants module.

Ensures all constants are properly defined and have valid values.
"""

import pytest
from mmofakelog.core.constants import (
    # Version
    VERSION,
    PACKAGE_NAME,
    # Defaults
    DEFAULT_OUTPUT_FORMAT,
    DEFAULT_LOG_COUNT,
    DEFAULT_BATCH_SIZE,
    DEFAULT_SERVER_ID,
    DEFAULT_TIME_SCALE,
    # Recurrence
    RECURRENCE_WEIGHTS,
    # AI
    DEFAULT_AI_MODEL,
    AI_MAX_TOKENS,
    AI_TEMPERATURE,
    AI_CACHE_TTL,
    AI_REQUEST_TIMEOUT,
    AI_MAX_RETRIES,
    # Output
    MAX_LOG_LINE_LENGTH,
    DEFAULT_TIMESTAMP_FORMAT,
    JSON_INDENT,
    FILE_ROTATION_SIZE,
    # Game world
    MAX_PLAYER_LEVEL,
    MIN_PLAYER_LEVEL,
    MAX_GOLD,
    MAX_INVENTORY_SLOTS,
    # Network
    MIN_LATENCY_MS,
    MAX_LATENCY_MS,
    PACKET_SIZE_MIN,
    PACKET_SIZE_MAX,
    # Server
    MIN_CPU_PERCENT,
    MAX_CPU_PERCENT,
    MIN_TPS,
    MAX_TPS,
    # Combat
    MIN_DAMAGE,
    MAX_DAMAGE,
    CRIT_MULTIPLIER,
    # Economy
    MIN_VENDOR_PRICE,
    MAX_VENDOR_PRICE,
    AUCTION_FEE_PERCENT,
    # Game data
    ZONES,
    ITEM_RARITIES,
    CHARACTER_CLASSES,
    CHARACTER_RACES,
    SERVER_REGIONS,
    CHAT_CHANNELS,
    LOGOUT_REASONS,
    ADMIN_ACTIONS,
    RISK_LEVELS,
    ERROR_CODES,
    PACKET_TYPES,
    DB_QUERY_TYPES,
    CACHE_TYPES,
)


class TestVersionConstants:
    """Tests for version-related constants."""

    def test_version_is_string(self):
        assert isinstance(VERSION, str)

    def test_version_format(self):
        # Version should be in semver format
        parts = VERSION.split(".")
        assert len(parts) >= 2
        assert all(p.isdigit() for p in parts[:2])

    def test_package_name(self):
        assert PACKAGE_NAME == "mmofakelog"


class TestDefaultConstants:
    """Tests for default configuration constants."""

    def test_default_output_format(self):
        assert DEFAULT_OUTPUT_FORMAT in ("json", "text", "ndjson")

    def test_default_log_count_positive(self):
        assert DEFAULT_LOG_COUNT > 0

    def test_default_batch_size_positive(self):
        assert DEFAULT_BATCH_SIZE > 0

    def test_default_server_id(self):
        assert isinstance(DEFAULT_SERVER_ID, str)
        assert len(DEFAULT_SERVER_ID) > 0

    def test_default_time_scale(self):
        assert DEFAULT_TIME_SCALE > 0


class TestRecurrenceWeights:
    """Tests for recurrence weight constants."""

    def test_all_patterns_have_weights(self):
        expected_patterns = [
            "VERY_FREQUENT",
            "FREQUENT",
            "NORMAL",
            "INFREQUENT",
            "RARE",
        ]
        for pattern in expected_patterns:
            assert pattern in RECURRENCE_WEIGHTS

    def test_weights_are_positive(self):
        for pattern, weight in RECURRENCE_WEIGHTS.items():
            assert weight > 0, f"{pattern} should have positive weight"

    def test_weights_order(self):
        # Very frequent should be higher than rare
        assert RECURRENCE_WEIGHTS["VERY_FREQUENT"] > RECURRENCE_WEIGHTS["RARE"]
        assert RECURRENCE_WEIGHTS["FREQUENT"] > RECURRENCE_WEIGHTS["NORMAL"]
        assert RECURRENCE_WEIGHTS["NORMAL"] > RECURRENCE_WEIGHTS["INFREQUENT"]


class TestAIConstants:
    """Tests for AI-related constants."""

    def test_ai_model_is_string(self):
        assert isinstance(DEFAULT_AI_MODEL, str)

    def test_ai_max_tokens_positive(self):
        assert AI_MAX_TOKENS > 0

    def test_ai_temperature_valid_range(self):
        assert 0 <= AI_TEMPERATURE <= 2.0

    def test_ai_cache_ttl_positive(self):
        assert AI_CACHE_TTL > 0

    def test_ai_timeout_reasonable(self):
        assert 1 <= AI_REQUEST_TIMEOUT <= 300

    def test_ai_max_retries_reasonable(self):
        assert 0 <= AI_MAX_RETRIES <= 10


class TestOutputConstants:
    """Tests for output-related constants."""

    def test_max_line_length_reasonable(self):
        assert MAX_LOG_LINE_LENGTH >= 1024

    def test_timestamp_format_valid(self):
        from datetime import datetime
        # Should not raise an error
        datetime.now().strftime(DEFAULT_TIMESTAMP_FORMAT)

    def test_json_indent_positive(self):
        assert JSON_INDENT >= 0

    def test_file_rotation_size_reasonable(self):
        # At least 1MB
        assert FILE_ROTATION_SIZE >= 1024 * 1024


class TestGameWorldConstants:
    """Tests for game world constants."""

    def test_player_level_range(self):
        assert MIN_PLAYER_LEVEL >= 1
        assert MAX_PLAYER_LEVEL > MIN_PLAYER_LEVEL

    def test_gold_range(self):
        assert MAX_GOLD > 0

    def test_inventory_slots_positive(self):
        assert MAX_INVENTORY_SLOTS > 0


class TestNetworkConstants:
    """Tests for network-related constants."""

    def test_latency_range(self):
        assert MIN_LATENCY_MS >= 0
        assert MAX_LATENCY_MS > MIN_LATENCY_MS

    def test_packet_size_range(self):
        assert PACKET_SIZE_MIN > 0
        assert PACKET_SIZE_MAX > PACKET_SIZE_MIN


class TestServerConstants:
    """Tests for server performance constants."""

    def test_cpu_percent_range(self):
        assert 0 <= MIN_CPU_PERCENT < MAX_CPU_PERCENT <= 100

    def test_tps_range(self):
        assert MIN_TPS > 0
        assert MAX_TPS >= MIN_TPS


class TestCombatConstants:
    """Tests for combat-related constants."""

    def test_damage_range(self):
        assert MIN_DAMAGE >= 0
        assert MAX_DAMAGE > MIN_DAMAGE

    def test_crit_multiplier(self):
        assert CRIT_MULTIPLIER >= 1.0


class TestEconomyConstants:
    """Tests for economy-related constants."""

    def test_vendor_price_range(self):
        assert MIN_VENDOR_PRICE >= 0
        assert MAX_VENDOR_PRICE > MIN_VENDOR_PRICE

    def test_auction_fee_percent(self):
        assert 0 <= AUCTION_FEE_PERCENT < 1


class TestGameDataConstants:
    """Tests for game data tuple constants."""

    def test_zones_not_empty(self):
        assert len(ZONES) > 0
        assert all(isinstance(z, str) for z in ZONES)

    def test_item_rarities_complete(self):
        expected = ["Poor", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Artifact"]
        assert set(expected) == set(ITEM_RARITIES)

    def test_character_classes_not_empty(self):
        assert len(CHARACTER_CLASSES) >= 9  # Classic classes
        assert "Warrior" in CHARACTER_CLASSES
        assert "Mage" in CHARACTER_CLASSES

    def test_character_races_not_empty(self):
        assert len(CHARACTER_RACES) >= 10
        assert "Human" in CHARACTER_RACES
        assert "Orc" in CHARACTER_RACES

    def test_server_regions_not_empty(self):
        assert len(SERVER_REGIONS) >= 4
        assert any("NA" in r for r in SERVER_REGIONS)
        assert any("EU" in r for r in SERVER_REGIONS)

    def test_chat_channels_complete(self):
        expected = ["say", "yell", "whisper", "party", "guild"]
        for ch in expected:
            assert ch in CHAT_CHANNELS

    def test_logout_reasons_not_empty(self):
        assert len(LOGOUT_REASONS) > 0
        assert "voluntary" in LOGOUT_REASONS

    def test_admin_actions_not_empty(self):
        assert len(ADMIN_ACTIONS) > 0
        assert "ban" in ADMIN_ACTIONS
        assert "kick" in ADMIN_ACTIONS

    def test_risk_levels_ordered(self):
        assert RISK_LEVELS == ("low", "medium", "high", "critical")

    def test_error_codes_not_empty(self):
        assert len(ERROR_CODES) > 0
        assert all(k.startswith("E") for k in ERROR_CODES.keys())

    def test_packet_types_not_empty(self):
        assert len(PACKET_TYPES) > 0
        # Should have both client (CMSG) and server (SMSG) messages
        assert any("CMSG" in p for p in PACKET_TYPES)
        assert any("SMSG" in p for p in PACKET_TYPES)

    def test_db_query_types_complete(self):
        expected = ["SELECT", "INSERT", "UPDATE", "DELETE"]
        for qt in expected:
            assert qt in DB_QUERY_TYPES

    def test_cache_types_not_empty(self):
        assert len(CACHE_TYPES) > 0
        assert "player_data" in CACHE_TYPES
