"""
Security and admin log generators.

Contains 15 log types for security events including:
- Authentication failures
- Suspicious activity detection
- Admin actions (ban, mute, kick)
- Audit logging
"""

import random
from typing import Any, Dict

from mmofakelog.core.constants import ADMIN_ACTIONS, RISK_LEVELS
from mmofakelog.core.registry import register_log_type
from mmofakelog.core.types import LogCategory, LogSeverity, RecurrencePattern
from mmofakelog.data.items import generate_item
from mmofakelog.data.names import (
    generate_character_name,
    generate_ip_address,
    generate_player_name,
)
from mmofakelog.data.zones import generate_zone, generate_location
from mmofakelog.generators.base import BaseLogGenerator


# =============================================================================
# AUTHENTICATION FAILURES
# =============================================================================


@register_log_type(
    name="security.login_failed",
    category=LogCategory.SECURITY,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.NORMAL,
    description="Failed login attempt",
    text_template="[{timestamp}] LOGIN_FAILED: {username} from {ip} (reason: {reason})",
)
class SecurityLoginFailedGenerator(BaseLogGenerator):
    """Generates failed login log entries."""

    REASONS = [
        "invalid_password", "account_not_found", "account_banned",
        "account_locked", "invalid_token", "expired_session",
        "region_blocked", "suspicious_activity",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "username": kwargs.get("username") or generate_player_name(),
            "ip": generate_ip_address(),
            "reason": random.choice(self.REASONS),
            "attempt_count": random.randint(1, 10),
        }


@register_log_type(
    name="security.account_locked",
    category=LogCategory.SECURITY,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Account locked due to failed attempts",
    text_template="[{timestamp}] ACCOUNT_LOCKED: {username} after {attempts} failed attempts (unlock: {unlock_time}min)",
)
class SecurityAccountLockedGenerator(BaseLogGenerator):
    """Generates account lock log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "username": kwargs.get("username") or generate_player_name(),
            "attempts": random.randint(3, 10),
            "unlock_time": random.choice([5, 15, 30, 60, 1440]),
            "ip": generate_ip_address(),
            "trigger": random.choice(["password_attempts", "suspicious_ip", "brute_force"]),
        }


# =============================================================================
# CHEAT DETECTION
# =============================================================================


@register_log_type(
    name="security.suspicious_activity",
    category=LogCategory.SECURITY,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Suspicious activity detected",
    text_template="[{timestamp}] SUSPICIOUS: {char_name} - {activity_type} (score: {risk_score})",
)
class SecuritySuspiciousActivityGenerator(BaseLogGenerator):
    """Generates suspicious activity log entries."""

    ACTIVITY_TYPES = [
        "unusual_gold_transfer", "rapid_level_gain", "impossible_movement",
        "automated_behavior", "item_duplication_attempt", "memory_modification",
        "packet_manipulation", "unusual_login_pattern", "multi_accounting",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "activity_type": random.choice(self.ACTIVITY_TYPES),
            "risk_score": random.randint(25, 100),
            "risk_level": random.choice(RISK_LEVELS),
            "auto_flagged": random.random() < 0.7,
            "zone": generate_zone(),
        }


@register_log_type(
    name="security.speed_hack",
    category=LogCategory.SECURITY,
    severity=LogSeverity.ERROR,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Speed hack detected",
    text_template="[{timestamp}] SPEED_HACK: {char_name} moved {distance}u in {time}ms (max: {max_distance}u)",
)
class SecuritySpeedHackGenerator(BaseLogGenerator):
    """Generates speed hack detection log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        time_ms = random.randint(100, 1000)
        max_distance = time_ms * 0.05  # Normal max speed
        actual_distance = max_distance * random.uniform(2, 10)  # Detected hack

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "distance": round(actual_distance, 1),
            "time": time_ms,
            "max_distance": round(max_distance, 1),
            "zone": generate_zone(),
            "action_taken": random.choice(["warning", "kick", "temp_ban", "flagged"]),
        }


@register_log_type(
    name="security.teleport_hack",
    category=LogCategory.SECURITY,
    severity=LogSeverity.ERROR,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Unauthorized teleport detected",
    text_template="[{timestamp}] TELEPORT_HACK: {char_name} unauthorized teleport {from_zone} -> {to_zone}",
)
class SecurityTeleportHackGenerator(BaseLogGenerator):
    """Generates teleport hack detection log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        from_zone = generate_zone()
        to_zone = generate_zone()

        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "from_zone": from_zone,
            "to_zone": to_zone,
            "distance": random.randint(1000, 50000),
            "action_taken": random.choice(["kick", "temp_ban", "flagged"]),
        }


@register_log_type(
    name="security.dupe_attempt",
    category=LogCategory.SECURITY,
    severity=LogSeverity.CRITICAL,
    recurrence=RecurrencePattern.RARE,
    description="Item duplication attempt",
    text_template="[{timestamp}] DUPE_ATTEMPT: {char_name} tried to duplicate {item_name}",
)
class SecurityDupeAttemptGenerator(BaseLogGenerator):
    """Generates dupe attempt log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item()
        return {
            "char_name": kwargs.get("char_name") or generate_character_name(),
            "item_name": item.name,
            "item_id": item.item_id,
            "method": random.choice([
                "trade_exploit", "mail_exploit", "guild_bank_exploit",
                "auction_exploit", "disconnect_timing",
            ]),
            "action_taken": "permanent_ban",
            "items_removed": random.randint(0, 10),
        }


# =============================================================================
# ADMIN ACTIONS
# =============================================================================


@register_log_type(
    name="admin.ban",
    category=LogCategory.SECURITY,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Player banned",
    text_template="[{timestamp}] BAN: {admin} banned {target} for {duration} (reason: {reason})",
)
class AdminBanGenerator(BaseLogGenerator):
    """Generates ban log entries."""

    REASONS = [
        "cheating", "harassment", "exploiting", "botting", "gold_selling",
        "account_sharing", "inappropriate_name", "scamming", "hate_speech",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        duration_days = random.choice([1, 3, 7, 14, 30, 180, 3650])  # 3650 = permanent
        return {
            "admin": f"GM_{random.choice(['Alpha', 'Beta', 'Gamma', 'Delta'])}",
            "target": kwargs.get("target") or generate_player_name(),
            "duration": "permanent" if duration_days >= 3650 else f"{duration_days}d",
            "duration_days": duration_days,
            "reason": random.choice(self.REASONS),
            "evidence_id": f"EVD-{random.randint(10000, 99999)}",
        }


@register_log_type(
    name="admin.unban",
    category=LogCategory.SECURITY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Player unbanned",
    text_template="[{timestamp}] UNBAN: {admin} unbanned {target} (reason: {reason})",
)
class AdminUnbanGenerator(BaseLogGenerator):
    """Generates unban log entries."""

    REASONS = [
        "appeal_approved", "ban_expired", "false_positive",
        "admin_error", "policy_change",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "admin": f"GM_{random.choice(['Alpha', 'Beta', 'Gamma', 'Delta'])}",
            "target": kwargs.get("target") or generate_player_name(),
            "reason": random.choice(self.REASONS),
            "original_ban_id": f"BAN-{random.randint(10000, 99999)}",
        }


@register_log_type(
    name="admin.mute",
    category=LogCategory.SECURITY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Player muted",
    text_template="[{timestamp}] MUTE: {admin} muted {target} for {duration} (reason: {reason})",
)
class AdminMuteGenerator(BaseLogGenerator):
    """Generates mute log entries."""

    REASONS = [
        "spam", "harassment", "advertising", "profanity",
        "inappropriate_content", "impersonation",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        duration_min = random.choice([5, 15, 30, 60, 180, 1440])
        return {
            "admin": f"GM_{random.choice(['Alpha', 'Beta', 'Gamma', 'Delta'])}",
            "target": kwargs.get("target") or generate_character_name(),
            "duration": f"{duration_min}min",
            "duration_minutes": duration_min,
            "reason": random.choice(self.REASONS),
            "channel": random.choice(["all", "say", "trade", "whisper"]),
        }


@register_log_type(
    name="admin.kick",
    category=LogCategory.SECURITY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Player kicked",
    text_template="[{timestamp}] KICK: {admin} kicked {target} (reason: {reason})",
)
class AdminKickGenerator(BaseLogGenerator):
    """Generates kick log entries."""

    REASONS = [
        "afk_abuse", "griefing", "harassment", "bug_abuse",
        "requested", "server_cleanup", "investigation",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "admin": f"GM_{random.choice(['Alpha', 'Beta', 'Gamma', 'Delta'])}",
            "target": kwargs.get("target") or generate_character_name(),
            "reason": random.choice(self.REASONS),
            "zone": generate_zone(),
        }


@register_log_type(
    name="admin.warning",
    category=LogCategory.SECURITY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Warning issued",
    text_template="[{timestamp}] WARNING: {admin} warned {target}: {message}",
)
class AdminWarningGenerator(BaseLogGenerator):
    """Generates warning log entries."""

    MESSAGES = [
        "Please follow the rules",
        "This is your first warning",
        "Continued behavior will result in a ban",
        "Watch your language",
        "Do not harass other players",
        "Exploiting is not allowed",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "admin": f"GM_{random.choice(['Alpha', 'Beta', 'Gamma', 'Delta'])}",
            "target": kwargs.get("target") or generate_character_name(),
            "message": random.choice(self.MESSAGES),
            "warning_count": random.randint(1, 3),
        }


@register_log_type(
    name="admin.command",
    category=LogCategory.SECURITY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Admin command executed",
    text_template="[{timestamp}] ADMIN_CMD: {admin} executed: {command}",
)
class AdminCommandGenerator(BaseLogGenerator):
    """Generates admin command log entries."""

    COMMANDS = [
        ".lookup player {target}",
        ".ticket list",
        ".server info",
        ".gm on",
        ".revive {target}",
        ".teleport {zone}",
        ".additem {item_id} 1",
        ".announce {message}",
        ".shutdown 300",
        ".ban account {target}",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        command = random.choice(self.COMMANDS)
        command = command.replace("{target}", generate_character_name())
        command = command.replace("{zone}", generate_zone())
        command = command.replace("{item_id}", str(random.randint(10000, 99999)))
        command = command.replace("{message}", "Server maintenance in 5 minutes")

        return {
            "admin": f"GM_{random.choice(['Alpha', 'Beta', 'Gamma', 'Delta'])}",
            "command": command,
            "success": random.random() > 0.05,
        }


@register_log_type(
    name="admin.grant_item",
    category=LogCategory.SECURITY,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Item granted by admin",
    text_template="[{timestamp}] GRANT_ITEM: {admin} gave {target} [{rarity}] {item_name} x{quantity}",
)
class AdminGrantItemGenerator(BaseLogGenerator):
    """Generates item grant log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        item = generate_item()
        return {
            "admin": f"GM_{random.choice(['Alpha', 'Beta', 'Gamma', 'Delta'])}",
            "target": kwargs.get("target") or generate_character_name(),
            "item_id": item.item_id,
            "item_name": item.name,
            "rarity": item.rarity,
            "quantity": random.randint(1, 10),
            "reason": random.choice(["bug_compensation", "event_reward", "testing", "customer_support"]),
        }


@register_log_type(
    name="security.audit_log",
    category=LogCategory.SECURITY,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Security audit trail",
    text_template="[{timestamp}] AUDIT: {action} by {actor} on {target}",
)
class SecurityAuditLogGenerator(BaseLogGenerator):
    """Generates audit trail log entries."""

    ACTIONS = [
        "password_changed", "email_changed", "2fa_enabled", "2fa_disabled",
        "session_created", "session_terminated", "permissions_modified",
        "character_restored", "gold_adjusted", "item_removed",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        action = random.choice(self.ACTIONS)
        is_admin = random.random() < 0.3

        return {
            "action": action,
            "actor": f"GM_{random.choice(['Alpha', 'Beta', 'Gamma'])}" if is_admin else generate_player_name(),
            "actor_type": "admin" if is_admin else "player",
            "target": kwargs.get("target") or generate_player_name(),
            "ip": generate_ip_address(),
            "details": {},
        }
