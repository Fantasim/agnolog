"""
Tests for all generator categories.

Tests that all registered generators produce valid log entries.
"""

from datetime import datetime

import pytest

from agnolog.core.factory import LogFactory
from agnolog.core.types import LogEntry


@pytest.fixture
def factory(populated_registry):
    """Factory with all generators."""
    return LogFactory(registry=populated_registry)


class TestPlayerGenerators:
    """Tests for player generators."""

    PLAYER_TYPES = [
        "player.login",
        "player.logout",
        "player.character_create",
        "player.character_delete",
        "player.level_up",
        "player.death",
        "player.respawn",
        "player.skill_use",
        "player.item_pickup",
        "player.item_drop",
        "player.item_use",
        "player.item_equip",
        "player.inventory_full",
        "player.chat_say",
        "player.chat_yell",
        "player.chat_whisper",
        "player.chat_guild",
        "player.chat_party",
        "player.chat_trade",
        "player.quest_accept",
        "player.quest_complete",
        "player.quest_abandon",
        "player.achievement",
        "player.mount_summon",
        "player.teleport",
    ]

    @pytest.mark.parametrize("log_type", PLAYER_TYPES)
    def test_player_generator_creates_entry(self, factory, log_type):
        """Each player generator should create a valid entry."""
        entry = factory.create(log_type)

        assert entry is not None, f"Failed to create {log_type}"
        assert isinstance(entry, LogEntry)
        assert entry.log_type == log_type
        assert entry.category == "PLAYER"

    def test_player_login_has_required_fields(self, factory):
        """player.login should have expected fields."""
        entry = factory.create("player.login")

        # Should have player identification
        assert any(field in entry.data for field in ["username", "character_name", "player_name"])

    def test_player_level_up_has_level(self, factory):
        """player.level_up should have level info."""
        entry = factory.create("player.level_up")

        assert any(field in entry.data for field in ["level", "new_level", "old_level"])

    def test_player_chat_has_message(self, factory):
        """Chat events should have message content."""
        chat_types = [
            "player.chat_say",
            "player.chat_yell",
            "player.chat_whisper",
        ]

        for log_type in chat_types:
            entry = factory.create(log_type)
            assert "message" in entry.data or "content" in entry.data


class TestServerGenerators:
    """Tests for server generators."""

    SERVER_TYPES = [
        "server.start",
        "server.stop",
        "server.restart",
        "server.tick",
        "server.cpu_usage",
        "server.memory_usage",
        "server.player_count",
        "server.world_save",
        "server.config_reload",
        "server.world_event_start",
        "server.world_event_end",
        "server.spawn_wave",
        "server.maintenance_start",
        "server.maintenance_end",
        "server.hotfix_applied",
    ]

    @pytest.mark.parametrize("log_type", SERVER_TYPES)
    def test_server_generator_creates_entry(self, factory, log_type):
        """Each server generator should create a valid entry."""
        entry = factory.create(log_type)

        assert entry is not None, f"Failed to create {log_type}"
        assert isinstance(entry, LogEntry)
        assert entry.log_type == log_type
        assert entry.category == "SERVER"

    def test_server_cpu_usage_has_percent(self, factory):
        """cpu_usage should have percentage."""
        entry = factory.create("server.cpu_usage")

        assert any(field in entry.data for field in ["cpu_percent", "percent", "usage"])

    def test_server_player_count_has_count(self, factory):
        """player_count should have count."""
        entry = factory.create("server.player_count")

        assert any(field in entry.data for field in ["count", "player_count", "players"])


class TestSecurityGenerators:
    """Tests for security generators."""

    SECURITY_TYPES = [
        "security.login_failed",
        "security.account_locked",
        "security.suspicious_activity",
        "security.speed_hack",
        "security.teleport_hack",
        "security.dupe_attempt",
        "admin.ban",
        "admin.unban",
        "admin.mute",
        "admin.kick",
        "admin.warning",
        "admin.command",
        "admin.grant_item",
        "security.audit_log",
    ]

    @pytest.mark.parametrize("log_type", SECURITY_TYPES)
    def test_security_generator_creates_entry(self, factory, log_type):
        """Each security generator should create a valid entry."""
        entry = factory.create(log_type)

        assert entry is not None, f"Failed to create {log_type}"
        assert isinstance(entry, LogEntry)
        assert entry.log_type == log_type
        assert entry.category == "SECURITY"

    def test_security_login_failed_has_reason(self, factory):
        """login_failed should have failure reason."""
        entry = factory.create("security.login_failed")

        assert any(field in entry.data for field in ["reason", "error", "failure_reason"])

    def test_admin_ban_has_target(self, factory):
        """ban should have target info."""
        entry = factory.create("admin.ban")

        assert any(field in entry.data for field in ["target", "username", "player", "banned_user"])


class TestEconomyGenerators:
    """Tests for economy generators."""

    ECONOMY_TYPES = [
        "economy.gold_gain",
        "economy.gold_spend",
        "economy.trade_request",
        "economy.trade_complete",
        "economy.trade_cancel",
        "economy.auction_list",
        "economy.auction_buy",
        "economy.auction_bid",
        "economy.auction_expire",
        "economy.vendor_buy",
        "economy.vendor_sell",
        "economy.mail_send",
        "economy.crafting_cost",
        "economy.repair_cost",
        "economy.tax_collected",
    ]

    @pytest.mark.parametrize("log_type", ECONOMY_TYPES)
    def test_economy_generator_creates_entry(self, factory, log_type):
        """Each economy generator should create a valid entry."""
        entry = factory.create(log_type)

        assert entry is not None, f"Failed to create {log_type}"
        assert isinstance(entry, LogEntry)
        assert entry.log_type == log_type
        assert entry.category == "ECONOMY"

    def test_economy_gold_gain_has_amount(self, factory):
        """gold_gain should have amount."""
        entry = factory.create("economy.gold_gain")

        assert any(field in entry.data for field in ["amount", "gold", "value"])

    def test_economy_trade_complete_has_participants(self, factory):
        """trade_complete should have participant info."""
        entry = factory.create("economy.trade_complete")

        # Should have info about trade
        assert len(entry.data) > 0


class TestCombatGenerators:
    """Tests for combat generators."""

    COMBAT_TYPES = [
        "combat.damage_dealt",
        "combat.damage_taken",
        "combat.heal",
        "combat.buff_apply",
        "combat.debuff_apply",
        "combat.mob_kill",
        "combat.mob_aggro",
        "combat.dungeon_enter",
        "combat.dungeon_complete",
        "combat.dungeon_wipe",
        "combat.boss_engage",
        "combat.boss_kill",
        "combat.raid_enter",
        "combat.raid_complete",
        "combat.pvp_kill",
        "combat.pvp_death",
        "combat.arena_start",
        "combat.arena_end",
        "combat.battleground_join",
        "combat.battleground_end",
    ]

    @pytest.mark.parametrize("log_type", COMBAT_TYPES)
    def test_combat_generator_creates_entry(self, factory, log_type):
        """Each combat generator should create a valid entry."""
        entry = factory.create(log_type)

        assert entry is not None, f"Failed to create {log_type}"
        assert isinstance(entry, LogEntry)
        assert entry.log_type == log_type
        assert entry.category == "COMBAT"

    def test_combat_damage_dealt_has_damage(self, factory):
        """damage_dealt should have damage info."""
        entry = factory.create("combat.damage_dealt")

        assert any(field in entry.data for field in ["damage", "amount", "value"])

    def test_combat_heal_has_amount(self, factory):
        """heal should have heal amount."""
        entry = factory.create("combat.heal")

        assert any(field in entry.data for field in ["amount", "heal", "healed"])

    def test_combat_mob_kill_has_target(self, factory):
        """mob_kill should have target info."""
        entry = factory.create("combat.mob_kill")

        assert any(
            field in entry.data for field in ["target", "mob", "enemy", "monster", "mob_name"]
        )


class TestTechnicalGenerators:
    """Tests for technical generators."""

    TECHNICAL_TYPES = [
        "technical.connection_open",
        "technical.connection_close",
        "technical.connection_timeout",
        "technical.packet_recv",
        "technical.packet_send",
        "technical.packet_malformed",
        "technical.latency",
        "technical.error",
        "technical.exception",
        "technical.database_query",
        "technical.database_error",
        "technical.cache_hit",
        "technical.cache_miss",
        "technical.rate_limit",
        "technical.queue_depth",
    ]

    @pytest.mark.parametrize("log_type", TECHNICAL_TYPES)
    def test_technical_generator_creates_entry(self, factory, log_type):
        """Each technical generator should create a valid entry."""
        entry = factory.create(log_type)

        assert entry is not None, f"Failed to create {log_type}"
        assert isinstance(entry, LogEntry)
        assert entry.log_type == log_type
        assert entry.category == "TECHNICAL"

    def test_technical_latency_has_ms(self, factory):
        """latency should have milliseconds."""
        entry = factory.create("technical.latency")

        assert any(field in entry.data for field in ["latency", "ms", "latency_ms"])

    def test_technical_error_has_message(self, factory):
        """error should have error message."""
        entry = factory.create("technical.error")

        assert any(field in entry.data for field in ["error", "message", "error_message"])


class TestAllGeneratorsDataQuality:
    """Tests for data quality across all generators."""

    def test_all_entries_have_data(self, factory, populated_registry):
        """All entries should have non-empty data."""
        for log_type in populated_registry.all_types():
            entry = factory.create(log_type)
            assert entry is not None, f"Failed to create {log_type}"
            assert entry.data is not None
            assert len(entry.data) > 0, f"{log_type} has empty data"

    def test_no_none_values_in_data(self, factory, populated_registry):
        """Data fields should not be None (except optional ones)."""
        # Some fields are legitimately optional/None
        optional_fields = {
            "error",
            "zone",
            "guild",
            "target_guild",
            "previous_bidder",  # auction_bid: first bid has no previous bidder
            "buyout",  # auction_list: not all auctions have buyout
        }

        for log_type in populated_registry.all_types():
            entry = factory.create(log_type)
            for key, value in entry.data.items():
                if key not in optional_fields:
                    assert value is not None, f"{log_type}.{key} is None"

    def test_consistent_timestamp(self, factory, populated_registry):
        """Entries should have consistent timestamp."""
        timestamp = datetime(2024, 1, 15, 12, 30, 45)

        for log_type in populated_registry.all_types():
            entry = factory.create(log_type, timestamp=timestamp)
            assert entry.timestamp == timestamp


class TestGeneratorCount:
    """Tests for generator count."""

    def test_at_least_100_generators(self, populated_registry):
        """Should have at least 100 generators."""
        count = populated_registry.count()
        assert count >= 100, f"Expected 100+ generators, got {count}"

    def test_all_categories_represented(self, populated_registry):
        """All categories should have generators."""
        # Use dynamic categories from registry
        for category in populated_registry.get_categories():
            types = populated_registry.get_by_category(category.upper())
            assert len(types) >= 10, f"Category {category} has only {len(types)} types"
