"""
Combat/PvE/PvP log generators.

Contains 20 log types for combat events including:
- Damage and healing
- Buffs and debuffs
- Monster kills
- Dungeons and raids
- PvP and arenas
"""

import random
from typing import Any, Dict

from mmofakelog.core.constants import (
    BLOCK_CHANCE,
    CHARACTER_CLASSES,
    CRIT_CHANCE,
    CRIT_MULTIPLIER,
    DODGE_CHANCE,
    MAX_BUFF_DURATION,
    MAX_DAMAGE,
    MAX_HEAL,
    MAX_MOB_XP,
    MIN_BUFF_DURATION,
    MIN_DAMAGE,
    MIN_HEAL,
    MIN_MOB_XP,
    PARRY_CHANCE,
)
from mmofakelog.core.registry import register_log_type
from mmofakelog.core.types import LogCategory, LogSeverity, RecurrencePattern
from mmofakelog.data.monsters import generate_boss, generate_monster
from mmofakelog.data.names import generate_character_name, generate_guild_name
from mmofakelog.data.skills import generate_random_skill_for_class
from mmofakelog.data.zones import (
    generate_arena,
    generate_battleground,
    generate_dungeon,
    generate_raid,
    generate_zone,
)
from mmofakelog.generators.base import BaseLogGenerator


# =============================================================================
# DAMAGE AND HEALING
# =============================================================================


@register_log_type(
    name="combat.damage_dealt",
    category=LogCategory.COMBAT,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.VERY_FREQUENT,
    description="Damage dealt",
    text_template="[{timestamp}] DMG: {attacker} -> {target} {damage} {damage_type} ({skill}) [{result}]",
)
class CombatDamageDealtGenerator(BaseLogGenerator):
    """Generates damage dealt log entries."""

    DAMAGE_TYPES = ["Physical", "Fire", "Frost", "Arcane", "Nature", "Shadow", "Holy"]
    RESULTS = ["hit", "crit", "miss", "dodge", "parry", "block", "absorb"]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        char_class = random.choice(CHARACTER_CLASSES)
        skill = generate_random_skill_for_class(char_class)

        # Determine result
        roll = random.random()
        if roll < CRIT_CHANCE:
            result = "crit"
            damage = random.randint(MIN_DAMAGE, MAX_DAMAGE) * 2
        elif roll < CRIT_CHANCE + DODGE_CHANCE:
            result = "dodge"
            damage = 0
        elif roll < CRIT_CHANCE + DODGE_CHANCE + PARRY_CHANCE:
            result = "parry"
            damage = 0
        elif roll < CRIT_CHANCE + DODGE_CHANCE + PARRY_CHANCE + BLOCK_CHANCE:
            result = "block"
            damage = random.randint(MIN_DAMAGE // 2, MAX_DAMAGE // 2)
        else:
            result = "hit"
            damage = random.randint(MIN_DAMAGE, MAX_DAMAGE)

        # Target is either mob or player
        if random.random() > 0.3:
            target = generate_monster().name
            target_type = "mob"
        else:
            target = generate_character_name()
            target_type = "player"

        return {
            "attacker": kwargs.get("attacker") or generate_character_name(),
            "target": target,
            "target_type": target_type,
            "damage": damage,
            "damage_type": random.choice(self.DAMAGE_TYPES),
            "skill": skill,
            "result": result,
            "overkill": max(0, damage - random.randint(100, 10000)) if result in ("hit", "crit") else 0,
        }


@register_log_type(
    name="combat.damage_taken",
    category=LogCategory.COMBAT,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.VERY_FREQUENT,
    description="Damage taken",
    text_template="[{timestamp}] DMG_TAKEN: {target} took {damage} {damage_type} from {source}",
)
class CombatDamageTakenGenerator(BaseLogGenerator):
    """Generates damage taken log entries."""

    DAMAGE_TYPES = ["Physical", "Fire", "Frost", "Arcane", "Nature", "Shadow", "Holy"]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        # Source is either mob or player
        if random.random() > 0.3:
            source = generate_monster().name
            source_type = "mob"
        else:
            source = generate_character_name()
            source_type = "player"

        damage = random.randint(MIN_DAMAGE, MAX_DAMAGE)
        absorbed = random.randint(0, damage // 4) if random.random() < 0.2 else 0

        return {
            "target": kwargs.get("target") or generate_character_name(),
            "source": source,
            "source_type": source_type,
            "damage": damage,
            "damage_absorbed": absorbed,
            "damage_type": random.choice(self.DAMAGE_TYPES),
            "health_remaining": random.randint(0, 50000),
        }


@register_log_type(
    name="combat.heal",
    category=LogCategory.COMBAT,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.VERY_FREQUENT,
    description="Healing done",
    text_template="[{timestamp}] HEAL: {healer} healed {target} for {amount} ({skill}) [{is_crit}]",
)
class CombatHealGenerator(BaseLogGenerator):
    """Generates healing log entries."""

    HEALING_CLASSES = ["Priest", "Paladin", "Shaman", "Druid", "Monk"]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        healer_class = random.choice(self.HEALING_CLASSES)
        skill = generate_random_skill_for_class(healer_class)
        is_crit = random.random() < CRIT_CHANCE

        amount = random.randint(MIN_HEAL, MAX_HEAL)
        if is_crit:
            amount = int(amount * CRIT_MULTIPLIER)

        healer = kwargs.get("healer") or generate_character_name()
        # Self-heal 30% of the time
        target = healer if random.random() < 0.3 else generate_character_name()

        return {
            "healer": healer,
            "healer_class": healer_class,
            "target": target,
            "amount": amount,
            "overheal": random.randint(0, amount // 2) if random.random() < 0.3 else 0,
            "skill": skill,
            "is_crit": "CRIT" if is_crit else "normal",
        }


# =============================================================================
# BUFFS AND DEBUFFS
# =============================================================================


@register_log_type(
    name="combat.buff_apply",
    category=LogCategory.COMBAT,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.FREQUENT,
    description="Buff applied",
    text_template="[{timestamp}] BUFF: {target} gained {buff_name} from {source} ({duration}s)",
)
class CombatBuffApplyGenerator(BaseLogGenerator):
    """Generates buff application log entries."""

    BUFFS = [
        "Power Word: Fortitude", "Mark of the Wild", "Arcane Intellect",
        "Blessing of Kings", "Bloodlust", "Heroism", "Battle Shout",
        "Trueshot Aura", "Devotion Aura", "Mana Spring", "Windfury",
        "Flask of the Titans", "Elixir of Giants", "Well Fed",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        target = kwargs.get("target") or generate_character_name()
        # Self-buff 40% of the time
        source = target if random.random() < 0.4 else generate_character_name()

        return {
            "target": target,
            "source": source,
            "buff_name": random.choice(self.BUFFS),
            "buff_id": random.randint(1000, 99999),
            "duration": random.randint(MIN_BUFF_DURATION, MAX_BUFF_DURATION),
            "stacks": random.randint(1, 5) if random.random() < 0.2 else 1,
        }


@register_log_type(
    name="combat.debuff_apply",
    category=LogCategory.COMBAT,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.FREQUENT,
    description="Debuff applied",
    text_template="[{timestamp}] DEBUFF: {target} afflicted with {debuff_name} from {source}",
)
class CombatDebuffApplyGenerator(BaseLogGenerator):
    """Generates debuff application log entries."""

    DEBUFFS = [
        "Curse of Agony", "Corruption", "Shadow Word: Pain", "Serpent Sting",
        "Rend", "Deep Wounds", "Mortal Strike", "Hunter's Mark",
        "Sunder Armor", "Faerie Fire", "Expose Armor", "Thunderclap",
        "Slow", "Crippling Poison", "Deadly Poison", "Mind Flay",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        # Target is usually mob
        if random.random() > 0.2:
            target = generate_monster().name
            target_type = "mob"
        else:
            target = generate_character_name()
            target_type = "player"

        return {
            "target": target,
            "target_type": target_type,
            "source": kwargs.get("source") or generate_character_name(),
            "debuff_name": random.choice(self.DEBUFFS),
            "debuff_id": random.randint(1000, 99999),
            "duration": random.randint(5, 60),
            "damage_per_tick": random.randint(50, 500) if random.random() < 0.5 else 0,
        }


# =============================================================================
# MONSTER COMBAT
# =============================================================================


@register_log_type(
    name="combat.mob_kill",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Monster killed",
    text_template="[{timestamp}] MOB_KILL: {char_name} killed {mob_name} (+{xp} XP)",
)
class CombatMobKillGenerator(BaseLogGenerator):
    """Generates mob kill log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        mob = generate_monster()
        xp = random.randint(MIN_MOB_XP, MAX_MOB_XP) * (3 if mob.is_elite else 1)

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "mob_id": mob.monster_id,
            "mob_name": mob.name,
            "mob_level": mob.level,
            "mob_type": mob.monster_type,
            "xp": xp,
            "is_elite": mob.is_elite,
            "is_rare": mob.is_rare,
            "zone": mob.zone,
        }


@register_log_type(
    name="combat.mob_aggro",
    category=LogCategory.COMBAT,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.FREQUENT,
    description="Mob aggro",
    text_template="[{timestamp}] AGGRO: {mob_name} aggroed on {char_name} in {zone}",
)
class CombatMobAggroGenerator(BaseLogGenerator):
    """Generates mob aggro log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        mob = generate_monster()
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "mob_id": mob.monster_id,
            "mob_name": mob.name,
            "mob_level": mob.level,
            "zone": mob.zone,
            "aggro_range": random.randint(10, 40),
        }


# =============================================================================
# DUNGEONS
# =============================================================================


@register_log_type(
    name="combat.dungeon_enter",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Dungeon entered",
    text_template="[{timestamp}] DUNGEON_ENTER: {party_leader}'s party entered {dungeon_name} ({party_size} players)",
)
class CombatDungeonEnterGenerator(BaseLogGenerator):
    """Generates dungeon enter log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        dungeon = generate_dungeon()
        party_size = random.randint(3, 5)
        party = [generate_character_name() for _ in range(party_size)]

        return {
            "party_leader": party[0],
            "party_members": party,
            "party_size": party_size,
            "dungeon_name": dungeon[0],
            "dungeon_level_min": dungeon[1],
            "dungeon_level_max": dungeon[2],
            "difficulty": random.choice(["normal", "heroic"]),
        }


@register_log_type(
    name="combat.dungeon_complete",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Dungeon completed",
    text_template="[{timestamp}] DUNGEON_CLEAR: {party_leader}'s party completed {dungeon_name} in {time_taken}",
)
class CombatDungeonCompleteGenerator(BaseLogGenerator):
    """Generates dungeon completion log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        dungeon = generate_dungeon()
        time_seconds = random.randint(900, 5400)  # 15-90 minutes

        return {
            "party_leader": kwargs.get("party_leader") or generate_character_name(),
            "dungeon_name": dungeon[0],
            "time_taken": f"{time_seconds // 60}m {time_seconds % 60}s",
            "time_seconds": time_seconds,
            "bosses_killed": random.randint(3, 7),
            "deaths": random.randint(0, 10),
            "difficulty": random.choice(["normal", "heroic"]),
        }


@register_log_type(
    name="combat.dungeon_wipe",
    category=LogCategory.COMBAT,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.NORMAL,
    description="Party wipe",
    text_template="[{timestamp}] WIPE: Party wiped in {dungeon_name} at {boss_name}",
)
class CombatDungeonWipeGenerator(BaseLogGenerator):
    """Generates dungeon wipe log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        dungeon = generate_dungeon()
        boss = generate_boss(dungeon=dungeon[0])

        return {
            "party_leader": kwargs.get("party_leader") or generate_character_name(),
            "dungeon_name": dungeon[0],
            "boss_name": boss.name,
            "attempt_number": random.randint(1, 10),
            "best_attempt_percent": random.randint(5, 95),
        }


# =============================================================================
# BOSSES
# =============================================================================


@register_log_type(
    name="combat.boss_engage",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Boss engaged",
    text_template="[{timestamp}] BOSS_ENGAGE: {party_leader}'s group engaged {boss_name}",
)
class CombatBossEngageGenerator(BaseLogGenerator):
    """Generates boss engage log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        is_raid = random.random() < 0.3
        if is_raid:
            raid = generate_raid()
            boss = generate_boss(raid=raid[0])
            location = raid[0]
        else:
            dungeon = generate_dungeon()
            boss = generate_boss(dungeon=dungeon[0])
            location = dungeon[0]

        return {
            "party_leader": kwargs.get("party_leader") or generate_character_name(),
            "boss_name": boss.name,
            "boss_health": boss.health,
            "location": location,
            "raid_size": random.choice([10, 25, 40]) if is_raid else 5,
        }


@register_log_type(
    name="combat.boss_kill",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Boss killed",
    text_template="[{timestamp}] BOSS_KILL: {party_leader}'s group defeated {boss_name} ({time_taken})",
)
class CombatBossKillGenerator(BaseLogGenerator):
    """Generates boss kill log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        is_raid = random.random() < 0.3
        if is_raid:
            raid = generate_raid()
            boss = generate_boss(raid=raid[0])
            location = raid[0]
        else:
            dungeon = generate_dungeon()
            boss = generate_boss(dungeon=dungeon[0])
            location = dungeon[0]

        time_seconds = random.randint(60, 600)

        return {
            "party_leader": kwargs.get("party_leader") or generate_character_name(),
            "boss_name": boss.name,
            "location": location,
            "time_taken": f"{time_seconds // 60}m {time_seconds % 60}s",
            "time_seconds": time_seconds,
            "deaths": random.randint(0, 20),
            "first_kill": random.random() < 0.05,
        }


# =============================================================================
# RAIDS
# =============================================================================


@register_log_type(
    name="combat.raid_enter",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Raid entered",
    text_template="[{timestamp}] RAID_ENTER: {raid_leader}'s raid entered {raid_name} ({raid_size} players)",
)
class CombatRaidEnterGenerator(BaseLogGenerator):
    """Generates raid enter log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        raid = generate_raid()
        raid_size = raid[1]

        return {
            "raid_leader": kwargs.get("raid_leader") or generate_character_name(),
            "raid_name": raid[0],
            "raid_size": raid_size,
            "guild": generate_guild_name() if random.random() > 0.3 else None,
        }


@register_log_type(
    name="combat.raid_complete",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.RARE,
    description="Raid cleared",
    text_template="[{timestamp}] RAID_CLEAR: {raid_leader}'s raid cleared {raid_name} ({bosses_killed} bosses)",
)
class CombatRaidCompleteGenerator(BaseLogGenerator):
    """Generates raid completion log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        raid = generate_raid()

        return {
            "raid_leader": kwargs.get("raid_leader") or generate_character_name(),
            "raid_name": raid[0],
            "bosses_killed": random.randint(5, 12),
            "time_hours": round(random.uniform(2, 6), 1),
            "guild": generate_guild_name() if random.random() > 0.3 else None,
            "first_clear": random.random() < 0.02,
        }


# =============================================================================
# PVP
# =============================================================================


@register_log_type(
    name="combat.pvp_kill",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="PvP kill",
    text_template="[{timestamp}] PVP_KILL: {killer} killed {victim} in {zone}",
)
class CombatPvpKillGenerator(BaseLogGenerator):
    """Generates PvP kill log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "killer": kwargs.get("killer") or generate_character_name(),
            "victim": kwargs.get("victim") or generate_character_name(),
            "killer_level": random.randint(20, 60),
            "victim_level": random.randint(20, 60),
            "zone": generate_zone(),
            "honor_gained": random.randint(1, 50),
        }


@register_log_type(
    name="combat.pvp_death",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="PvP death",
    text_template="[{timestamp}] PVP_DEATH: {victim} killed by {killer}",
)
class CombatPvpDeathGenerator(BaseLogGenerator):
    """Generates PvP death log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "victim": kwargs.get("victim") or generate_character_name(),
            "killer": kwargs.get("killer") or generate_character_name(),
            "zone": generate_zone(),
            "death_count_session": random.randint(1, 20),
        }


@register_log_type(
    name="combat.arena_start",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Arena match started",
    text_template="[{timestamp}] ARENA_START: {team1} vs {team2} in {arena} ({bracket})",
)
class CombatArenaStartGenerator(BaseLogGenerator):
    """Generates arena match start log entries."""

    BRACKETS = ["2v2", "3v3", "5v5"]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        bracket = random.choice(self.BRACKETS)
        team_size = int(bracket[0])

        team1 = [generate_character_name() for _ in range(team_size)]
        team2 = [generate_character_name() for _ in range(team_size)]

        return {
            "team1": ", ".join(team1),
            "team1_members": team1,
            "team2": ", ".join(team2),
            "team2_members": team2,
            "bracket": bracket,
            "arena": generate_arena(),
            "team1_rating": random.randint(1000, 2500),
            "team2_rating": random.randint(1000, 2500),
        }


@register_log_type(
    name="combat.arena_end",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Arena match ended",
    text_template="[{timestamp}] ARENA_END: {winner} defeated {loser} ({duration}s)",
)
class CombatArenaEndGenerator(BaseLogGenerator):
    """Generates arena match end log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "winner": kwargs.get("winner") or generate_character_name(),
            "loser": kwargs.get("loser") or generate_character_name(),
            "duration": random.randint(30, 600),
            "rating_change": random.randint(-30, 30),
            "arena": generate_arena(),
        }


@register_log_type(
    name="combat.battleground_join",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Battleground joined",
    text_template="[{timestamp}] BG_JOIN: {char_name} joined {bg_name} (queue time: {queue_time}s)",
)
class CombatBattlegroundJoinGenerator(BaseLogGenerator):
    """Generates battleground join log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "bg_name": generate_battleground(),
            "queue_time": random.randint(30, 1800),
            "team": random.choice(["Alliance", "Horde"]),
        }


@register_log_type(
    name="combat.battleground_end",
    category=LogCategory.COMBAT,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Battleground concluded",
    text_template="[{timestamp}] BG_END: {bg_name} - {winner} wins (score: {score})",
)
class CombatBattlegroundEndGenerator(BaseLogGenerator):
    """Generates battleground end log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        bg = generate_battleground()
        winner = random.choice(["Alliance", "Horde"])

        # Score format depends on BG type
        if "Gulch" in bg:
            score = f"{random.randint(0, 3)}-{random.randint(0, 3)}"
        elif "Basin" in bg or "Eye" in bg:
            score = f"{random.randint(1000, 2000)}-{random.randint(500, 1999)}"
        else:
            score = f"{random.randint(100, 600)}-{random.randint(100, 600)}"

        return {
            "bg_name": bg,
            "winner": winner,
            "score": score,
            "duration_minutes": random.randint(10, 45),
            "honor_gained": random.randint(100, 500),
        }
