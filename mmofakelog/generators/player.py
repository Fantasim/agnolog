"""
Player action log generators.

Contains 25 log types for player actions including:
- Authentication (login, logout, character creation)
- Progression (level up, achievements)
- Inventory (pickup, drop, equip)
- Chat (say, yell, whisper, party, guild, trade)
- Quests (accept, complete, abandon)
- Social (party, guild, friends)
"""

import random
from typing import Any, Dict, Optional

from mmofakelog.core.constants import (
    CHARACTER_CLASSES,
    CHARACTER_RACES,
    CHAT_CHANNELS,
    LOGOUT_REASONS,
    MAX_PLAYER_LEVEL,
    MAX_SESSION_DURATION,
    MIN_SESSION_DURATION,
    SERVER_REGIONS,
)
from mmofakelog.core.registry import register_log_type
from mmofakelog.core.types import LogCategory, LogSeverity, RecurrencePattern
from mmofakelog.data.items import generate_item
from mmofakelog.data.names import (
    generate_character_name,
    generate_guild_name,
    generate_ip_address,
    generate_player_name,
    generate_session_id,
    get_chat_message,
)
from mmofakelog.data.quests import generate_quest
from mmofakelog.data.skills import generate_random_skill_for_class
from mmofakelog.data.zones import generate_zone, generate_location
from mmofakelog.generators.base import BaseLogGenerator


# =============================================================================
# AUTHENTICATION
# =============================================================================


@register_log_type(
    name="player.login",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Player login event",
    text_template="[{timestamp}] LOGIN: {username} ({char_name}) from {ip} (region: {region})",
)
class PlayerLoginGenerator(BaseLogGenerator):
    """Generates player login log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        username = kwargs.get("username") or generate_player_name()
        char_class = random.choice(CHARACTER_CLASSES)

        return {
            "username": username,
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "ip": kwargs.get("ip") or generate_ip_address(),
            "region": random.choice(SERVER_REGIONS),
            "client_version": f"1.{random.randint(0, 5)}.{random.randint(0, 20)}",
            "session_id": generate_session_id(),
            "level": random.randint(1, MAX_PLAYER_LEVEL),
            "class": char_class,
            "race": random.choice(CHARACTER_RACES),
        }


@register_log_type(
    name="player.logout",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Player logout event",
    text_template="[{timestamp}] LOGOUT: {username} (session: {duration}s, reason: {reason})",
)
class PlayerLogoutGenerator(BaseLogGenerator):
    """Generates player logout log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "username": kwargs.get("username") or generate_player_name(),
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "duration": random.randint(MIN_SESSION_DURATION, MAX_SESSION_DURATION),
            "reason": random.choice(LOGOUT_REASONS),
            "session_id": kwargs.get("session_id") or generate_session_id(),
        }


@register_log_type(
    name="player.character_create",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="New character creation",
    text_template="[{timestamp}] CHAR_CREATE: {username} created {char_name} ({race} {class})",
)
class PlayerCharacterCreateGenerator(BaseLogGenerator):
    """Generates character creation log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "username": kwargs.get("username") or generate_player_name(),
            "char_name": generate_character_name(),
            "class": random.choice(CHARACTER_CLASSES),
            "race": random.choice(CHARACTER_RACES),
            "customization": {
                "skin_color": random.randint(1, 10),
                "hair_style": random.randint(1, 20),
                "hair_color": random.randint(1, 15),
            },
        }


@register_log_type(
    name="player.character_delete",
    category=LogCategory.PLAYER,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.RARE,
    description="Character deletion",
    text_template="[{timestamp}] CHAR_DELETE: {username} deleted {char_name} (level {level})",
)
class PlayerCharacterDeleteGenerator(BaseLogGenerator):
    """Generates character deletion log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "username": kwargs.get("username") or generate_player_name(),
            "char_name": generate_character_name(),
            "level": random.randint(1, MAX_PLAYER_LEVEL),
            "playtime_hours": random.randint(1, 5000),
        }


# =============================================================================
# PROGRESSION
# =============================================================================


@register_log_type(
    name="player.level_up",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Player level up",
    text_template="[{timestamp}] LEVEL_UP: {char_name} reached level {new_level}",
)
class PlayerLevelUpGenerator(BaseLogGenerator):
    """Generates level up log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        new_level = kwargs.get("level") or random.randint(2, MAX_PLAYER_LEVEL)
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "old_level": new_level - 1,
            "new_level": new_level,
            "zone": generate_zone(level=new_level),
            "time_at_level": random.randint(30, 600),  # minutes
        }


@register_log_type(
    name="player.achievement",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Achievement unlocked",
    text_template='[{timestamp}] ACHIEVEMENT: {char_name} earned "{achievement_name}" (+{points} pts)',
)
class PlayerAchievementGenerator(BaseLogGenerator):
    """Generates achievement unlock log entries."""

    ACHIEVEMENTS = [
        ("Explorer", 10), ("Dungeon Master", 20), ("Dragon Slayer", 50),
        ("Master Crafter", 15), ("PvP Champion", 25), ("Loremaster", 30),
        ("Speed Runner", 10), ("Perfectionist", 40), ("Guild Leader", 15),
        ("First Blood", 5), ("Undying", 25), ("The Insane", 100),
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        achievement = random.choice(self.ACHIEVEMENTS)
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "achievement_name": achievement[0],
            "achievement_id": random.randint(1000, 9999),
            "points": achievement[1],
            "category": random.choice(["Exploration", "Dungeons", "PvP", "Quests", "Professions"]),
        }


@register_log_type(
    name="player.death",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Player death",
    text_template="[{timestamp}] DEATH: {char_name} killed by {killer} at {zone}",
)
class PlayerDeathGenerator(BaseLogGenerator):
    """Generates player death log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        from mmofakelog.data.monsters import generate_monster

        zone = generate_zone()
        is_pvp = random.random() < 0.2

        if is_pvp:
            killer = generate_character_name()
            killer_type = "player"
        else:
            mob = generate_monster(zone=zone)
            killer = mob.name
            killer_type = "mob"

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "killer": killer,
            "killer_type": killer_type,
            "zone": zone,
            "level": random.randint(1, MAX_PLAYER_LEVEL),
            "durability_loss": random.randint(5, 15),
        }


@register_log_type(
    name="player.respawn",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Player respawn",
    text_template="[{timestamp}] RESPAWN: {char_name} at {location} ({respawn_type})",
)
class PlayerRespawnGenerator(BaseLogGenerator):
    """Generates player respawn log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        location = generate_location()
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "location": str(location),
            "zone": location.zone,
            "respawn_type": random.choice(["graveyard", "spirit_healer", "soulstone", "battleground"]),
            "time_dead": random.randint(5, 300),
        }


# =============================================================================
# INVENTORY
# =============================================================================


@register_log_type(
    name="player.item_pickup",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Item picked up",
    text_template="[{timestamp}] PICKUP: {char_name} looted [{rarity}] {item_name} x{quantity}",
)
class PlayerItemPickupGenerator(BaseLogGenerator):
    """Generates item pickup log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item()
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "rarity": item.rarity,
            "quantity": random.randint(1, item.max_stack) if item.stackable else 1,
            "source": random.choice(["loot", "quest_reward", "mail", "trade"]),
        }


@register_log_type(
    name="player.item_drop",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Item dropped/destroyed",
    text_template="[{timestamp}] DROP: {char_name} dropped {item_name} x{quantity}",
)
class PlayerItemDropGenerator(BaseLogGenerator):
    """Generates item drop log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item()
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "quantity": random.randint(1, 10),
            "zone": generate_zone(),
        }


@register_log_type(
    name="player.item_use",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Item consumed/used",
    text_template="[{timestamp}] USE: {char_name} used {item_name}",
)
class PlayerItemUseGenerator(BaseLogGenerator):
    """Generates item use log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item(item_type=random.choice([
            "Health Potion", "Mana Potion", "Elixir", "Flask", "Food", "Drink", "Scroll"
        ]))
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "effect": random.choice(["heal", "buff", "restore_mana", "teleport"]),
        }


@register_log_type(
    name="player.item_equip",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Equipment change",
    text_template="[{timestamp}] EQUIP: {char_name} equipped [{rarity}] {item_name} in {slot}",
)
class PlayerItemEquipGenerator(BaseLogGenerator):
    """Generates item equip log entries."""

    SLOTS = [
        "Head", "Shoulders", "Chest", "Hands", "Legs", "Feet",
        "Main Hand", "Off Hand", "Ranged", "Trinket", "Ring", "Neck", "Back"
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        from mmofakelog.data.items import ARMOR_TYPES, WEAPON_TYPES
        item = generate_item(item_type=random.choice(ARMOR_TYPES + WEAPON_TYPES))
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "rarity": item.rarity,
            "slot": random.choice(self.SLOTS),
            "item_level": item.level,
        }


@register_log_type(
    name="player.inventory_full",
    category=LogCategory.PLAYER,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.NORMAL,
    description="Inventory full warning",
    text_template="[{timestamp}] INV_FULL: {char_name} inventory full, could not loot {item_name}",
)
class PlayerInventoryFullGenerator(BaseLogGenerator):
    """Generates inventory full log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item()
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_name": item.name,
            "item_rarity": item.rarity,
            "slots_used": random.randint(115, 120),
            "slots_total": 120,
        }


# =============================================================================
# CHAT
# =============================================================================


@register_log_type(
    name="player.chat_say",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Local chat message",
    text_template="[{timestamp}] [SAY] {char_name}: {message}",
    requires_ai=True,
)
class PlayerChatSayGenerator(BaseLogGenerator):
    """Generates local chat log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        char_name = kwargs.get("char_name") or generate_character_name()
        zone = kwargs.get("zone") or generate_zone()

        if self._ai_client:
            message = self._ai_client.generate_chat_message(
                context=f"casual gameplay in {zone}",
                player_name=char_name,
                channel="say",
            )
        else:
            message = get_chat_message("say")

        return {
            "char_name": char_name,
            "message": message,
            "zone": zone,
        }


@register_log_type(
    name="player.chat_yell",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Yell chat message",
    text_template="[{timestamp}] [YELL] {char_name}: {message}",
    requires_ai=True,
)
class PlayerChatYellGenerator(BaseLogGenerator):
    """Generates yell chat log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        char_name = kwargs.get("char_name") or generate_character_name()

        if self._ai_client:
            message = self._ai_client.generate_chat_message(
                context="exciting moment",
                player_name=char_name,
                channel="yell",
            )
        else:
            message = get_chat_message("yell")

        return {
            "char_name": char_name,
            "message": message,
            "zone": generate_zone(),
        }


@register_log_type(
    name="player.chat_whisper",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Private whisper message",
    text_template="[{timestamp}] [WHISPER] {from_char} -> {to_char}: {message}",
    requires_ai=True,
)
class PlayerChatWhisperGenerator(BaseLogGenerator):
    """Generates whisper log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        from_char = kwargs.get("from_char") or generate_character_name()
        to_char = kwargs.get("to_char") or generate_character_name()

        if self._ai_client:
            message = self._ai_client.generate_chat_message(
                context="private conversation",
                player_name=from_char,
                channel="whisper",
            )
        else:
            message = get_chat_message("whisper")

        return {
            "from_char": from_char,
            "to_char": to_char,
            "message": message,
        }


@register_log_type(
    name="player.chat_party",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Party chat message",
    text_template="[{timestamp}] [PARTY] {char_name}: {message}",
    requires_ai=True,
)
class PlayerChatPartyGenerator(BaseLogGenerator):
    """Generates party chat log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        char_name = kwargs.get("char_name") or generate_character_name()

        if self._ai_client:
            message = self._ai_client.generate_chat_message(
                context="dungeon group",
                player_name=char_name,
                channel="party",
            )
        else:
            message = get_chat_message("party")

        return {
            "char_name": char_name,
            "message": message,
            "party_size": random.randint(2, 5),
        }


@register_log_type(
    name="player.chat_guild",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Guild chat message",
    text_template="[{timestamp}] [GUILD:{guild}] {char_name}: {message}",
    requires_ai=True,
)
class PlayerChatGuildGenerator(BaseLogGenerator):
    """Generates guild chat log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        char_name = kwargs.get("char_name") or generate_character_name()
        guild = kwargs.get("guild") or generate_guild_name()

        if self._ai_client:
            message = self._ai_client.generate_chat_message(
                context="guild socializing",
                player_name=char_name,
                channel="guild",
            )
        else:
            message = get_chat_message("guild")

        return {
            "char_name": char_name,
            "guild": guild,
            "message": message,
        }


@register_log_type(
    name="player.chat_trade",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Trade chat message",
    text_template="[{timestamp}] [TRADE] {char_name}: {message}",
    requires_ai=True,
)
class PlayerChatTradeGenerator(BaseLogGenerator):
    """Generates trade chat log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        char_name = kwargs.get("char_name") or generate_character_name()

        if self._ai_client:
            message = self._ai_client.generate_chat_message(
                context="trading",
                player_name=char_name,
                channel="trade",
            )
        else:
            message = get_chat_message("trade")

        return {
            "char_name": char_name,
            "message": message,
            "city": random.choice(["Stormwind", "Orgrimmar", "Ironforge", "Thunder Bluff"]),
        }


# =============================================================================
# QUESTS
# =============================================================================


@register_log_type(
    name="player.quest_accept",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Quest accepted",
    text_template='[{timestamp}] QUEST_ACCEPT: {char_name} accepted "{quest_name}"',
)
class PlayerQuestAcceptGenerator(BaseLogGenerator):
    """Generates quest accept log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        quest = generate_quest()
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "quest_id": quest.quest_id,
            "quest_name": quest.name,
            "quest_level": quest.level,
            "zone": quest.zone,
            "quest_type": quest.quest_type,
        }


@register_log_type(
    name="player.quest_complete",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Quest completed",
    text_template='[{timestamp}] QUEST_COMPLETE: {char_name} completed "{quest_name}" (+{xp} XP, +{gold}g)',
)
class PlayerQuestCompleteGenerator(BaseLogGenerator):
    """Generates quest completion log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        quest = generate_quest()
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "quest_id": quest.quest_id,
            "quest_name": quest.name,
            "xp": quest.xp_reward,
            "gold": quest.gold_reward,
            "time_to_complete": random.randint(60, 3600),  # seconds
        }


@register_log_type(
    name="player.quest_abandon",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Quest abandoned",
    text_template='[{timestamp}] QUEST_ABANDON: {char_name} abandoned "{quest_name}"',
)
class PlayerQuestAbandonGenerator(BaseLogGenerator):
    """Generates quest abandon log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        quest = generate_quest()
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "quest_id": quest.quest_id,
            "quest_name": quest.name,
            "progress_percent": random.randint(0, 80),
        }


# =============================================================================
# MOVEMENT AND TRAVEL
# =============================================================================


@register_log_type(
    name="player.teleport",
    category=LogCategory.PLAYER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Player teleported",
    text_template="[{timestamp}] TELEPORT: {char_name} from {from_zone} to {to_zone} ({method})",
)
class PlayerTeleportGenerator(BaseLogGenerator):
    """Generates teleport log entries."""

    METHODS = [
        "hearthstone", "mage_portal", "warlock_summon", "flight_master",
        "ship", "zeppelin", "dungeon_finder", "battleground",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        from_zone = generate_zone()
        to_zone = generate_zone()
        while to_zone == from_zone:
            to_zone = generate_zone()

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "from_zone": from_zone,
            "to_zone": to_zone,
            "method": random.choice(self.METHODS),
        }


@register_log_type(
    name="player.mount_summon",
    category=LogCategory.PLAYER,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.FREQUENT,
    description="Mount summoned",
    text_template="[{timestamp}] MOUNT: {char_name} summoned {mount_name}",
)
class PlayerMountSummonGenerator(BaseLogGenerator):
    """Generates mount summon log entries."""

    MOUNTS = [
        "Swift Brown Horse", "Striped Frostsaber", "Swift Mechanostrider",
        "Swift Mistsaber", "Timber Wolf", "Dire Wolf", "Kodo",
        "Raptor", "Skeletal Horse", "Hawkstrider", "Elekk",
        "Gryphon", "Wind Rider", "Dragon", "Phoenix",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "mount_name": random.choice(self.MOUNTS),
            "mount_speed": random.choice([60, 100, 150, 310]),  # Speed %
            "zone": generate_zone(),
        }


@register_log_type(
    name="player.skill_use",
    category=LogCategory.PLAYER,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.VERY_FREQUENT,
    description="Skill/ability used",
    text_template="[{timestamp}] SKILL: {char_name} used {skill_name} on {target}",
)
class PlayerSkillUseGenerator(BaseLogGenerator):
    """Generates skill use log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        char_class = kwargs.get("class") or random.choice(CHARACTER_CLASSES)
        skill = generate_random_skill_for_class(char_class)

        target_type = random.choice(["mob", "player", "self"])
        if target_type == "self":
            target = kwargs.get("char_name") or generate_character_name()
        elif target_type == "player":
            target = generate_character_name()
        else:
            from mmofakelog.data.monsters import generate_monster
            target = generate_monster().name

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "skill_name": skill,
            "target": target,
            "target_type": target_type,
            "class": char_class,
        }
