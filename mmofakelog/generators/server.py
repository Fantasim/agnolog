"""
Server event log generators.

Contains 15 log types for server events including:
- Lifecycle (start, stop, restart)
- Performance (CPU, memory, tick rate)
- World events
- Maintenance
"""

import random
from typing import Any, Dict

from mmofakelog.core.constants import (
    MAX_CPU_PERCENT,
    MAX_MEMORY_PERCENT,
    MAX_TPS,
    MIN_CPU_PERCENT,
    MIN_MEMORY_PERCENT,
    MIN_TPS,
    TICK_TIME_MS_MAX,
    TICK_TIME_MS_MIN,
    TYPICAL_CPU_PERCENT,
    TYPICAL_MEMORY_PERCENT,
    VERSION,
)
from mmofakelog.core.registry import register_log_type
from mmofakelog.core.types import LogCategory, LogSeverity, RecurrencePattern
from mmofakelog.data.monsters import generate_monster, WORLD_BOSSES
from mmofakelog.data.zones import generate_zone, ZONES
from mmofakelog.generators.base import BaseLogGenerator


# =============================================================================
# LIFECYCLE
# =============================================================================


@register_log_type(
    name="server.start",
    category=LogCategory.SERVER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.RARE,
    description="Server startup",
    text_template="[{timestamp}] SERVER_START: {server_id} v{version} started ({startup_time}ms)",
)
class ServerStartGenerator(BaseLogGenerator):
    """Generates server startup log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "server_id": kwargs.get("server_id") or f"world-{random.randint(1, 10)}",
            "version": VERSION,
            "startup_time": random.randint(5000, 30000),
            "config_loaded": True,
            "plugins_loaded": random.randint(10, 50),
            "maps_loaded": random.randint(50, 100),
        }


@register_log_type(
    name="server.stop",
    category=LogCategory.SERVER,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.RARE,
    description="Server shutdown",
    text_template="[{timestamp}] SERVER_STOP: {server_id} shutdown (reason: {reason}, uptime: {uptime_hours}h)",
)
class ServerStopGenerator(BaseLogGenerator):
    """Generates server shutdown log entries."""

    REASONS = [
        "scheduled_maintenance", "emergency", "update", "crash_recovery",
        "resource_exhaustion", "admin_command", "hardware_failure",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "server_id": kwargs.get("server_id") or f"world-{random.randint(1, 10)}",
            "reason": random.choice(self.REASONS),
            "uptime_hours": random.randint(1, 720),  # Up to 30 days
            "players_disconnected": random.randint(0, 5000),
            "graceful": random.random() > 0.1,
        }


@register_log_type(
    name="server.restart",
    category=LogCategory.SERVER,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.RARE,
    description="Server restart",
    text_template="[{timestamp}] SERVER_RESTART: {server_id} restarting (countdown: {countdown}s)",
)
class ServerRestartGenerator(BaseLogGenerator):
    """Generates server restart log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "server_id": kwargs.get("server_id") or f"world-{random.randint(1, 10)}",
            "countdown": random.choice([15, 30, 60, 300, 900]),
            "reason": random.choice(["hotfix", "maintenance", "update", "crash_recovery"]),
            "estimated_downtime": random.randint(5, 60),  # minutes
        }


# =============================================================================
# PERFORMANCE
# =============================================================================


@register_log_type(
    name="server.tick",
    category=LogCategory.SERVER,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.VERY_FREQUENT,
    description="Server tick timing",
    text_template="[{timestamp}] TICK: #{tick_id} ({tick_time}ms, {entity_count} entities, TPS: {tps})",
)
class ServerTickGenerator(BaseLogGenerator):
    """Generates server tick log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        # Simulate occasional lag spikes
        if random.random() < 0.05:
            tick_time = random.randint(100, 500)  # Lag spike
            tps = random.randint(5, 15)
        else:
            tick_time = random.randint(TICK_TIME_MS_MIN, TICK_TIME_MS_MAX)
            tps = random.randint(MIN_TPS, MAX_TPS)

        return {
            "tick_id": random.randint(1, 1000000000),
            "tick_time": tick_time,
            "entity_count": random.randint(10000, 100000),
            "tps": tps,
            "world_time": random.randint(0, 24000),  # In-game time
        }


@register_log_type(
    name="server.cpu_usage",
    category=LogCategory.SERVER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="CPU usage metrics",
    text_template="[{timestamp}] CPU: {cpu_percent}% (avg: {cpu_avg}%, cores: {cpu_cores})",
)
class ServerCpuUsageGenerator(BaseLogGenerator):
    """Generates CPU usage log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        # Weighted toward typical usage
        cpu = random.gauss(TYPICAL_CPU_PERCENT, 15)
        cpu = max(MIN_CPU_PERCENT, min(MAX_CPU_PERCENT, cpu))

        return {
            "cpu_percent": round(cpu, 1),
            "cpu_avg": round(random.gauss(TYPICAL_CPU_PERCENT, 10), 1),
            "cpu_cores": random.choice([4, 8, 16, 32, 64]),
            "load_1m": round(random.uniform(0.5, 4.0), 2),
            "load_5m": round(random.uniform(0.5, 3.5), 2),
            "load_15m": round(random.uniform(0.5, 3.0), 2),
        }


@register_log_type(
    name="server.memory_usage",
    category=LogCategory.SERVER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Memory usage metrics",
    text_template="[{timestamp}] MEMORY: {used_mb}MB / {total_mb}MB ({percent}%)",
)
class ServerMemoryUsageGenerator(BaseLogGenerator):
    """Generates memory usage log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        total_mb = random.choice([8192, 16384, 32768, 65536])
        percent = random.gauss(TYPICAL_MEMORY_PERCENT, 10)
        percent = max(MIN_MEMORY_PERCENT, min(MAX_MEMORY_PERCENT, percent))
        used_mb = int(total_mb * percent / 100)

        return {
            "used_mb": used_mb,
            "total_mb": total_mb,
            "percent": round(percent, 1),
            "swap_used_mb": random.randint(0, 1024),
            "swap_total_mb": 2048,
        }


@register_log_type(
    name="server.player_count",
    category=LogCategory.SERVER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Online player count",
    text_template="[{timestamp}] PLAYERS: {count} online (peak: {peak}, capacity: {capacity})",
)
class ServerPlayerCountGenerator(BaseLogGenerator):
    """Generates player count log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        capacity = 5000
        count = random.randint(100, capacity)
        peak = max(count, random.randint(count, capacity))

        return {
            "count": count,
            "peak": peak,
            "capacity": capacity,
            "queue": max(0, count - capacity + random.randint(-100, 500)),
            "unique_today": random.randint(count, count * 3),
        }


# =============================================================================
# WORLD STATE
# =============================================================================


@register_log_type(
    name="server.world_save",
    category=LogCategory.SERVER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="World state saved",
    text_template="[{timestamp}] WORLD_SAVE: Saved {entity_count} entities in {duration}ms",
)
class ServerWorldSaveGenerator(BaseLogGenerator):
    """Generates world save log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "entity_count": random.randint(100000, 1000000),
            "duration": random.randint(1000, 10000),
            "player_count": random.randint(100, 5000),
            "items_saved": random.randint(1000000, 10000000),
            "size_mb": random.randint(100, 2000),
        }


@register_log_type(
    name="server.config_reload",
    category=LogCategory.SERVER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.RARE,
    description="Configuration reloaded",
    text_template="[{timestamp}] CONFIG_RELOAD: Reloaded {config_file} ({changes} changes)",
)
class ServerConfigReloadGenerator(BaseLogGenerator):
    """Generates config reload log entries."""

    CONFIG_FILES = [
        "server.conf", "world.conf", "rates.conf", "anticheat.conf",
        "chat.conf", "guild.conf", "pvp.conf", "loot.conf",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "config_file": random.choice(self.CONFIG_FILES),
            "changes": random.randint(1, 20),
            "admin": f"Admin{random.randint(1, 10)}",
        }


@register_log_type(
    name="server.world_event_start",
    category=LogCategory.SERVER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="World event started",
    text_template='[{timestamp}] WORLD_EVENT_START: "{event_name}" started in {zone}',
)
class ServerWorldEventStartGenerator(BaseLogGenerator):
    """Generates world event start log entries."""

    EVENTS = [
        "Darkmoon Faire", "Lunar Festival", "Love is in the Air",
        "Noblegarden", "Children's Week", "Midsummer Fire Festival",
        "Brewfest", "Hallow's End", "Pilgrim's Bounty", "Winter Veil",
        "Elemental Invasion", "Zombie Plague", "World PvP Event",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "event_name": random.choice(self.EVENTS),
            "event_id": random.randint(100, 999),
            "zone": random.choice(ZONES),
            "duration_hours": random.choice([24, 48, 168, 336]),
        }


@register_log_type(
    name="server.world_event_end",
    category=LogCategory.SERVER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="World event ended",
    text_template='[{timestamp}] WORLD_EVENT_END: "{event_name}" ended (participants: {participants})',
)
class ServerWorldEventEndGenerator(BaseLogGenerator):
    """Generates world event end log entries."""

    EVENTS = ServerWorldEventStartGenerator.EVENTS

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "event_name": random.choice(self.EVENTS),
            "event_id": random.randint(100, 999),
            "participants": random.randint(1000, 50000),
            "rewards_given": random.randint(500, 25000),
        }


@register_log_type(
    name="server.spawn_wave",
    category=LogCategory.SERVER,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.FREQUENT,
    description="Mob spawn wave",
    text_template="[{timestamp}] SPAWN: {count} {mob_type} spawned in {zone}",
)
class ServerSpawnWaveGenerator(BaseLogGenerator):
    """Generates spawn wave log entries."""

    MOB_TYPES = [
        "wolves", "bandits", "undead", "elementals", "demons",
        "beasts", "humanoids", "giants", "dragonkin", "aberrations",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "count": random.randint(5, 50),
            "mob_type": random.choice(self.MOB_TYPES),
            "zone": generate_zone(),
            "spawn_point": f"spawn_{random.randint(1, 100)}",
        }


# =============================================================================
# MAINTENANCE
# =============================================================================


@register_log_type(
    name="server.maintenance_start",
    category=LogCategory.SERVER,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.RARE,
    description="Scheduled maintenance starting",
    text_template="[{timestamp}] MAINTENANCE_START: Scheduled maintenance begun (est. {duration} min)",
)
class ServerMaintenanceStartGenerator(BaseLogGenerator):
    """Generates maintenance start log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "duration": random.choice([15, 30, 60, 120, 240, 480]),
            "reason": random.choice(["weekly_reset", "patch", "hotfix", "emergency", "hardware"]),
            "affected_realms": random.randint(1, 50),
        }


@register_log_type(
    name="server.maintenance_end",
    category=LogCategory.SERVER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.RARE,
    description="Maintenance completed",
    text_template="[{timestamp}] MAINTENANCE_END: Maintenance completed ({actual_duration} min)",
)
class ServerMaintenanceEndGenerator(BaseLogGenerator):
    """Generates maintenance end log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "actual_duration": random.randint(10, 300),
            "issues_resolved": random.randint(0, 10),
            "patches_applied": random.randint(0, 5),
        }


@register_log_type(
    name="server.hotfix_applied",
    category=LogCategory.SERVER,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.RARE,
    description="Hotfix deployed",
    text_template="[{timestamp}] HOTFIX: Applied patch {patch_id} ({description})",
)
class ServerHotfixAppliedGenerator(BaseLogGenerator):
    """Generates hotfix log entries."""

    DESCRIPTIONS = [
        "Fixed crash on dungeon load",
        "Corrected item stats",
        "Resolved exploit",
        "Updated drop rates",
        "Fixed quest completion bug",
        "Patched security vulnerability",
        "Corrected NPC behavior",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "patch_id": f"HF-{random.randint(2024001, 2024999)}",
            "description": random.choice(self.DESCRIPTIONS),
            "requires_restart": random.random() < 0.3,
            "severity": random.choice(["low", "medium", "high", "critical"]),
        }
