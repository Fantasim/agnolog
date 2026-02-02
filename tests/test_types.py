"""
Tests for mmofakelog.core.types module.

Tests all enums, dataclasses, and protocols.
"""

import pytest
from datetime import datetime
from mmofakelog.core.types import (
    # Enums
    LogCategory,
    LogSeverity,
    LogFormat,
    RecurrencePattern,
    ItemRarity,
    Faction,
    DamageType,
    CombatResult,
    ConnectionState,
    QuestState,
    TradeState,
    AuctionState,
    # Dataclasses
    LogTypeMetadata,
    LogEntry,
    PlayerInfo,
    ItemInfo,
    CombatEvent,
    QuestInfo,
    GuildInfo,
    ServerMetrics,
    NetworkMetrics,
)


class TestLogCategory:
    """Tests for LogCategory enum."""

    def test_all_categories_exist(self):
        expected = ["PLAYER", "SERVER", "SECURITY", "ECONOMY", "COMBAT", "TECHNICAL"]
        for cat in expected:
            assert hasattr(LogCategory, cat)

    def test_category_count(self):
        assert len(LogCategory) == 6


class TestLogSeverity:
    """Tests for LogSeverity enum."""

    def test_all_severities_exist(self):
        expected = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]
        for sev in expected:
            assert hasattr(LogSeverity, sev)

    def test_severity_values_ordered(self):
        assert LogSeverity.DEBUG.value < LogSeverity.INFO.value
        assert LogSeverity.INFO.value < LogSeverity.WARNING.value
        assert LogSeverity.WARNING.value < LogSeverity.ERROR.value
        assert LogSeverity.ERROR.value < LogSeverity.CRITICAL.value


class TestLogFormat:
    """Tests for LogFormat enum."""

    def test_formats_exist(self):
        assert hasattr(LogFormat, "JSON")
        assert hasattr(LogFormat, "TEXT")


class TestRecurrencePattern:
    """Tests for RecurrencePattern enum."""

    def test_all_patterns_exist(self):
        expected = ["VERY_FREQUENT", "FREQUENT", "NORMAL", "INFREQUENT", "RARE"]
        for pattern in expected:
            assert hasattr(RecurrencePattern, pattern)


class TestItemRarity:
    """Tests for ItemRarity enum."""

    def test_all_rarities_exist(self):
        expected = ["POOR", "COMMON", "UNCOMMON", "RARE", "EPIC", "LEGENDARY", "ARTIFACT"]
        for rarity in expected:
            assert hasattr(ItemRarity, rarity)


class TestFaction:
    """Tests for Faction enum."""

    def test_factions_exist(self):
        assert hasattr(Faction, "ALLIANCE")
        assert hasattr(Faction, "HORDE")
        assert hasattr(Faction, "NEUTRAL")


class TestDamageType:
    """Tests for DamageType enum."""

    def test_damage_types_exist(self):
        expected = ["PHYSICAL", "FIRE", "FROST", "ARCANE", "NATURE", "SHADOW", "HOLY"]
        for dt in expected:
            assert hasattr(DamageType, dt)


class TestCombatResult:
    """Tests for CombatResult enum."""

    def test_combat_results_exist(self):
        expected = ["HIT", "CRITICAL", "MISS", "DODGE", "PARRY", "BLOCK", "RESIST", "ABSORB"]
        for cr in expected:
            assert hasattr(CombatResult, cr)


class TestConnectionState:
    """Tests for ConnectionState enum."""

    def test_connection_states_exist(self):
        expected = [
            "CONNECTING", "CONNECTED", "AUTHENTICATING",
            "AUTHENTICATED", "DISCONNECTING", "DISCONNECTED"
        ]
        for cs in expected:
            assert hasattr(ConnectionState, cs)


class TestQuestState:
    """Tests for QuestState enum."""

    def test_quest_states_exist(self):
        expected = [
            "AVAILABLE", "IN_PROGRESS", "COMPLETED",
            "TURNED_IN", "FAILED", "ABANDONED"
        ]
        for qs in expected:
            assert hasattr(QuestState, qs)


class TestTradeState:
    """Tests for TradeState enum."""

    def test_trade_states_exist(self):
        expected = ["INITIATED", "PENDING", "ACCEPTED", "CANCELLED", "COMPLETED"]
        for ts in expected:
            assert hasattr(TradeState, ts)


class TestAuctionState:
    """Tests for AuctionState enum."""

    def test_auction_states_exist(self):
        expected = ["LISTED", "BID", "SOLD", "EXPIRED", "CANCELLED"]
        for auction_state in expected:
            assert hasattr(AuctionState, auction_state)


class TestLogTypeMetadata:
    """Tests for LogTypeMetadata dataclass."""

    def test_basic_creation(self):
        meta = LogTypeMetadata(
            name="player.login",
            category=LogCategory.PLAYER,
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Player login event",
            text_template="[{timestamp}] LOGIN: {username}",
        )
        assert meta.name == "player.login"
        assert meta.category == LogCategory.PLAYER
        assert meta.requires_ai is False
        assert meta.tags == ()

    def test_with_optional_fields(self):
        meta = LogTypeMetadata(
            name="player.chat",
            category=LogCategory.PLAYER,
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.FREQUENT,
            description="Player chat message",
            text_template="[{timestamp}] CHAT: {message}",
            requires_ai=True,
            tags=("chat", "social"),
        )
        assert meta.requires_ai is True
        assert "chat" in meta.tags

    def test_is_frozen(self):
        meta = LogTypeMetadata(
            name="test.type",
            category=LogCategory.PLAYER,
            severity=LogSeverity.INFO,
            recurrence=RecurrencePattern.NORMAL,
            description="Test",
            text_template="Test",
        )
        with pytest.raises(AttributeError):
            meta.name = "changed"

    def test_empty_name_raises(self):
        with pytest.raises(ValueError, match="cannot be empty"):
            LogTypeMetadata(
                name="",
                category=LogCategory.PLAYER,
                severity=LogSeverity.INFO,
                recurrence=RecurrencePattern.NORMAL,
                description="Test",
                text_template="Test",
            )

    def test_non_namespaced_name_raises(self):
        with pytest.raises(ValueError, match="namespaced"):
            LogTypeMetadata(
                name="invalid",
                category=LogCategory.PLAYER,
                severity=LogSeverity.INFO,
                recurrence=RecurrencePattern.NORMAL,
                description="Test",
                text_template="Test",
            )


class TestLogEntry:
    """Tests for LogEntry dataclass."""

    def test_basic_creation(self):
        timestamp = datetime.now()
        entry = LogEntry(
            log_type="player.login",
            timestamp=timestamp,
            severity=LogSeverity.INFO,
            category=LogCategory.PLAYER,
            data={"username": "TestPlayer"},
        )
        assert entry.log_type == "player.login"
        assert entry.timestamp == timestamp
        assert entry.data["username"] == "TestPlayer"
        assert entry.server_id is None
        assert entry.session_id is None

    def test_with_optional_fields(self):
        entry = LogEntry(
            log_type="player.login",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category=LogCategory.PLAYER,
            data={},
            server_id="server-01",
            session_id="sess-12345",
        )
        assert entry.server_id == "server-01"
        assert entry.session_id == "sess-12345"

    def test_to_dict(self):
        timestamp = datetime(2024, 1, 15, 12, 30, 45)
        entry = LogEntry(
            log_type="player.login",
            timestamp=timestamp,
            severity=LogSeverity.INFO,
            category=LogCategory.PLAYER,
            data={"username": "TestPlayer", "level": 42},
            server_id="server-01",
        )
        result = entry.to_dict()

        assert result["log_type"] == "player.login"
        assert result["timestamp"] == timestamp.isoformat()
        assert result["severity"] == "INFO"
        assert result["category"] == "PLAYER"
        assert result["username"] == "TestPlayer"
        assert result["level"] == 42
        assert result["server_id"] == "server-01"

    def test_to_dict_without_optional(self):
        entry = LogEntry(
            log_type="player.login",
            timestamp=datetime.now(),
            severity=LogSeverity.INFO,
            category=LogCategory.PLAYER,
            data={},
        )
        result = entry.to_dict()
        assert "server_id" not in result
        assert "session_id" not in result


class TestPlayerInfo:
    """Tests for PlayerInfo dataclass."""

    def test_basic_creation(self):
        player = PlayerInfo(
            username="testuser",
            character_name="DragonSlayer",
            level=42,
            character_class="Warrior",
            race="Human",
            faction=Faction.ALLIANCE,
        )
        assert player.username == "testuser"
        assert player.character_name == "DragonSlayer"
        assert player.faction == Faction.ALLIANCE

    def test_str_representation(self):
        player = PlayerInfo(
            username="testuser",
            character_name="DragonSlayer",
            level=42,
            character_class="Warrior",
            race="Human",
            faction=Faction.ALLIANCE,
        )
        result = str(player)
        assert "DragonSlayer" in result
        assert "42" in result
        assert "Warrior" in result


class TestItemInfo:
    """Tests for ItemInfo dataclass."""

    def test_basic_creation(self):
        item = ItemInfo(
            item_id=12345,
            name="Sword of Doom",
            rarity=ItemRarity.EPIC,
            item_type="Weapon",
            level=60,
            value=1000,
        )
        assert item.name == "Sword of Doom"
        assert item.rarity == ItemRarity.EPIC

    def test_str_representation(self):
        item = ItemInfo(
            item_id=12345,
            name="Sword of Doom",
            rarity=ItemRarity.EPIC,
            item_type="Weapon",
            level=60,
            value=1000,
        )
        result = str(item)
        assert "EPIC" in result
        assert "Sword of Doom" in result


class TestCombatEvent:
    """Tests for CombatEvent dataclass."""

    def test_basic_creation(self):
        event = CombatEvent(
            attacker="DragonSlayer",
            target="Orc Grunt",
            skill="Heroic Strike",
            damage=500,
            damage_type=DamageType.PHYSICAL,
            result=CombatResult.HIT,
        )
        assert event.attacker == "DragonSlayer"
        assert event.damage == 500
        assert event.is_critical is False


class TestQuestInfo:
    """Tests for QuestInfo dataclass."""

    def test_basic_creation(self):
        quest = QuestInfo(
            quest_id=100,
            name="Kill the Dragon",
            level=60,
            zone="Dragon's Lair",
            xp_reward=5000,
            gold_reward=100,
        )
        assert quest.name == "Kill the Dragon"
        assert quest.objectives == []


class TestGuildInfo:
    """Tests for GuildInfo dataclass."""

    def test_basic_creation(self):
        guild = GuildInfo(
            guild_id=1,
            name="Epic Raiders",
            faction=Faction.ALLIANCE,
            level=10,
            member_count=100,
            leader="GuildMaster",
        )
        assert guild.name == "Epic Raiders"
        assert guild.faction == Faction.ALLIANCE


class TestServerMetrics:
    """Tests for ServerMetrics dataclass."""

    def test_basic_creation(self):
        metrics = ServerMetrics(
            cpu_percent=45.5,
            memory_percent=60.0,
            memory_used_mb=8000,
            memory_total_mb=16000,
            player_count=500,
            entity_count=10000,
            tick_time_ms=45.0,
            tps=20,
        )
        assert metrics.cpu_percent == 45.5
        assert metrics.tps == 20


class TestNetworkMetrics:
    """Tests for NetworkMetrics dataclass."""

    def test_basic_creation(self):
        metrics = NetworkMetrics(
            latency_ms=50,
            packets_in=1000,
            packets_out=1500,
            bytes_in=50000,
            bytes_out=75000,
            packet_loss_percent=0.5,
        )
        assert metrics.latency_ms == 50
        assert metrics.packet_loss_percent == 0.5
