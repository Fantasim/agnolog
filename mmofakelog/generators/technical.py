"""
Technical log generators.

Contains 15 log types for technical events including:
- Network connections
- Packet processing
- Latency metrics
- Errors and exceptions
- Database and cache operations
"""

import random
from typing import Any, Dict

from mmofakelog.core.constants import (
    CACHE_TYPES,
    CONNECTION_TIMEOUT_MS,
    DB_QUERY_TYPES,
    ERROR_CODES,
    MAX_LATENCY_MS,
    MIN_LATENCY_MS,
    PACKET_SIZE_MAX,
    PACKET_SIZE_MIN,
    PACKET_TYPES,
    SPIKE_LATENCY_MS,
    TYPICAL_LATENCY_MS,
)
from mmofakelog.core.registry import register_log_type
from mmofakelog.core.types import LogCategory, LogSeverity, RecurrencePattern
from mmofakelog.data.names import generate_ip_address, generate_session_id
from mmofakelog.generators.base import BaseLogGenerator


# =============================================================================
# NETWORK CONNECTIONS
# =============================================================================


@register_log_type(
    name="technical.connection_open",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="New connection established",
    text_template="[{timestamp}] CONN_OPEN: {client_ip}:{port} (protocol: {protocol})",
)
class TechnicalConnectionOpenGenerator(BaseLogGenerator):
    """Generates connection open log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "client_ip": generate_ip_address(),
            "port": random.randint(1024, 65535),
            "protocol": random.choice(["TCP", "UDP", "WebSocket"]),
            "connection_id": f"conn_{random.randint(100000, 999999)}",
            "ssl": random.random() > 0.1,
            "client_version": f"1.{random.randint(0, 5)}.{random.randint(0, 20)}",
        }


@register_log_type(
    name="technical.connection_close",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Connection closed",
    text_template="[{timestamp}] CONN_CLOSE: {client_ip}:{port} (reason: {reason}, duration: {duration}s)",
)
class TechnicalConnectionCloseGenerator(BaseLogGenerator):
    """Generates connection close log entries."""

    REASONS = [
        "client_disconnect", "server_close", "timeout", "error",
        "kick", "maintenance", "handoff",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "client_ip": generate_ip_address(),
            "port": random.randint(1024, 65535),
            "reason": random.choice(self.REASONS),
            "duration": random.randint(1, 28800),  # Up to 8 hours
            "bytes_sent": random.randint(1000, 100000000),
            "bytes_received": random.randint(1000, 50000000),
            "packets_sent": random.randint(100, 1000000),
            "packets_received": random.randint(100, 500000),
        }


@register_log_type(
    name="technical.connection_timeout",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.NORMAL,
    description="Connection timeout",
    text_template="[{timestamp}] CONN_TIMEOUT: {client_ip} after {timeout}ms (last_activity: {last_activity}s ago)",
)
class TechnicalConnectionTimeoutGenerator(BaseLogGenerator):
    """Generates connection timeout log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "client_ip": generate_ip_address(),
            "timeout": random.randint(CONNECTION_TIMEOUT_MS // 2, CONNECTION_TIMEOUT_MS * 2),
            "last_activity": random.randint(30, 300),
            "connection_id": f"conn_{random.randint(100000, 999999)}",
            "session_id": generate_session_id(),
        }


# =============================================================================
# PACKET PROCESSING
# =============================================================================


@register_log_type(
    name="technical.packet_recv",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.VERY_FREQUENT,
    description="Packet received",
    text_template="[{timestamp}] PKT_RECV: {packet_type} from {client} ({size}b)",
)
class TechnicalPacketRecvGenerator(BaseLogGenerator):
    """Generates packet receive log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "packet_type": random.choice(PACKET_TYPES),
            "packet_id": random.randint(1, 1000000000),
            "client": f"{generate_ip_address()}:{random.randint(1024, 65535)}",
            "size": random.randint(PACKET_SIZE_MIN, PACKET_SIZE_MAX),
            "sequence": random.randint(1, 1000000),
            "compressed": random.random() < 0.3,
        }


@register_log_type(
    name="technical.packet_send",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.VERY_FREQUENT,
    description="Packet sent",
    text_template="[{timestamp}] PKT_SEND: {packet_type} to {client} ({size}b)",
)
class TechnicalPacketSendGenerator(BaseLogGenerator):
    """Generates packet send log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "packet_type": random.choice(PACKET_TYPES),
            "packet_id": random.randint(1, 1000000000),
            "client": f"{generate_ip_address()}:{random.randint(1024, 65535)}",
            "size": random.randint(PACKET_SIZE_MIN, PACKET_SIZE_MAX),
            "sequence": random.randint(1, 1000000),
            "compressed": random.random() < 0.3,
        }


@register_log_type(
    name="technical.packet_malformed",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Malformed packet received",
    text_template="[{timestamp}] PKT_BAD: Malformed {packet_type} from {client} ({reason})",
)
class TechnicalPacketMalformedGenerator(BaseLogGenerator):
    """Generates malformed packet log entries."""

    REASONS = [
        "invalid_header", "checksum_mismatch", "invalid_size",
        "unknown_opcode", "truncated", "encryption_error",
        "invalid_sequence", "protocol_violation",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        return {
            "packet_type": random.choice(PACKET_TYPES),
            "client": f"{generate_ip_address()}:{random.randint(1024, 65535)}",
            "reason": random.choice(self.REASONS),
            "raw_size": random.randint(1, PACKET_SIZE_MAX),
            "action": random.choice(["dropped", "logged", "flagged"]),
        }


# =============================================================================
# LATENCY
# =============================================================================


@register_log_type(
    name="technical.latency",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.FREQUENT,
    description="Latency measurement",
    text_template="[{timestamp}] LATENCY: {client} ping {latency}ms (avg: {avg}ms, jitter: {jitter}ms)",
)
class TechnicalLatencyGenerator(BaseLogGenerator):
    """Generates latency log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        # Mostly normal, occasional spike
        if random.random() < 0.05:
            latency = random.randint(MAX_LATENCY_MS, SPIKE_LATENCY_MS)
        else:
            latency = int(random.gauss(TYPICAL_LATENCY_MS, 20))
            latency = max(MIN_LATENCY_MS, min(latency, MAX_LATENCY_MS))

        return {
            "client": f"{generate_ip_address()}:{random.randint(1024, 65535)}",
            "session_id": generate_session_id(),
            "latency": latency,
            "avg": random.randint(TYPICAL_LATENCY_MS - 20, TYPICAL_LATENCY_MS + 20),
            "jitter": random.randint(1, 30),
            "packet_loss": round(random.uniform(0, 2), 2),
        }


# =============================================================================
# ERRORS
# =============================================================================


@register_log_type(
    name="technical.error",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.ERROR,
    recurrence=RecurrencePattern.NORMAL,
    description="General error",
    text_template="[{timestamp}] ERROR: {error_code} - {message}",
)
class TechnicalErrorGenerator(BaseLogGenerator):
    """Generates error log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        error_code = random.choice(list(ERROR_CODES.keys()))
        return {
            "error_code": error_code,
            "message": ERROR_CODES[error_code],
            "module": random.choice([
                "auth", "world", "chat", "combat", "trade",
                "guild", "mail", "auction", "quest", "inventory",
            ]),
            "recoverable": random.random() > 0.2,
        }


@register_log_type(
    name="technical.exception",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.ERROR,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Exception caught",
    text_template="[{timestamp}] EXCEPTION: {exception_type}: {message} at {location}",
)
class TechnicalExceptionGenerator(BaseLogGenerator):
    """Generates exception log entries."""

    EXCEPTIONS = [
        ("NullPointerException", "Object reference not set"),
        ("IndexOutOfBoundsException", "Index was outside the bounds of the array"),
        ("InvalidOperationException", "Operation is not valid due to the current state"),
        ("TimeoutException", "The operation has timed out"),
        ("IOException", "Unable to read data from the connection"),
        ("SQLException", "Error executing database query"),
        ("OutOfMemoryError", "Java heap space"),
        ("StackOverflowError", "Maximum recursion depth exceeded"),
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        exc = random.choice(self.EXCEPTIONS)
        return {
            "exception_type": exc[0],
            "message": exc[1],
            "location": f"com.game.{random.choice(['world', 'combat', 'network', 'db'])}.{random.choice(['Handler', 'Manager', 'Service', 'Controller'])}.{random.choice(['process', 'handle', 'execute', 'run'])}",
            "stack_trace_id": f"trace_{random.randint(100000, 999999)}",
            "thread": f"Worker-{random.randint(1, 32)}",
        }


# =============================================================================
# DATABASE
# =============================================================================


@register_log_type(
    name="technical.database_query",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.FREQUENT,
    description="Database query executed",
    text_template="[{timestamp}] DB_QUERY: {query_type} ({duration}ms, {rows} rows)",
)
class TechnicalDatabaseQueryGenerator(BaseLogGenerator):
    """Generates database query log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        query_type = random.choice(DB_QUERY_TYPES)

        # Duration varies by query type
        durations = {
            "SELECT": (1, 100),
            "INSERT": (1, 50),
            "UPDATE": (1, 50),
            "DELETE": (1, 30),
            "TRANSACTION": (5, 200),
            "STORED_PROC": (10, 500),
            "INDEX_SCAN": (1, 50),
            "TABLE_SCAN": (50, 1000),
        }
        min_dur, max_dur = durations.get(query_type, (1, 100))

        return {
            "query_type": query_type,
            "duration": random.randint(min_dur, max_dur),
            "rows": random.randint(0, 10000),
            "table": random.choice([
                "characters", "items", "guilds", "mail", "auctions",
                "quests", "achievements", "inventory", "stats",
            ]),
            "connection_pool": f"pool_{random.randint(1, 5)}",
        }


@register_log_type(
    name="technical.database_error",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.ERROR,
    recurrence=RecurrencePattern.INFREQUENT,
    description="Database error",
    text_template="[{timestamp}] DB_ERROR: {error_code} - {message}",
)
class TechnicalDatabaseErrorGenerator(BaseLogGenerator):
    """Generates database error log entries."""

    ERRORS = [
        ("CONN_LOST", "Connection to database lost"),
        ("TIMEOUT", "Query execution timeout"),
        ("DEADLOCK", "Transaction deadlock detected"),
        ("CONSTRAINT", "Constraint violation"),
        ("DUPLICATE", "Duplicate key violation"),
        ("DISK_FULL", "Disk space exhausted"),
        ("CORRUPT", "Data corruption detected"),
        ("POOL_EXHAUSTED", "Connection pool exhausted"),
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        error = random.choice(self.ERRORS)
        return {
            "error_code": error[0],
            "message": error[1],
            "query_type": random.choice(DB_QUERY_TYPES),
            "table": random.choice(["characters", "items", "guilds", "mail"]),
            "retry_count": random.randint(0, 3),
            "recovered": random.random() > 0.3,
        }


# =============================================================================
# CACHE
# =============================================================================


@register_log_type(
    name="technical.cache_hit",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.VERY_FREQUENT,
    description="Cache hit",
    text_template="[{timestamp}] CACHE_HIT: {cache_key} ({cache_type}, age: {age}ms)",
)
class TechnicalCacheHitGenerator(BaseLogGenerator):
    """Generates cache hit log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        cache_type = random.choice(CACHE_TYPES)
        return {
            "cache_key": f"{cache_type}:{random.randint(10000, 99999)}",
            "cache_type": cache_type,
            "age": random.randint(1, 3600000),  # Up to 1 hour in ms
            "size_bytes": random.randint(100, 100000),
            "ttl_remaining": random.randint(0, 3600),
        }


@register_log_type(
    name="technical.cache_miss",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.DEBUG,
    recurrence=RecurrencePattern.FREQUENT,
    description="Cache miss",
    text_template="[{timestamp}] CACHE_MISS: {cache_key} ({cache_type}, fetch_time: {fetch_time}ms)",
)
class TechnicalCacheMissGenerator(BaseLogGenerator):
    """Generates cache miss log entries."""

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        cache_type = random.choice(CACHE_TYPES)
        return {
            "cache_key": f"{cache_type}:{random.randint(10000, 99999)}",
            "cache_type": cache_type,
            "fetch_time": random.randint(1, 500),
            "reason": random.choice(["not_found", "expired", "evicted", "first_access"]),
            "populated": random.random() > 0.1,
        }


# =============================================================================
# RATE LIMITING
# =============================================================================


@register_log_type(
    name="technical.rate_limit",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.WARNING,
    recurrence=RecurrencePattern.NORMAL,
    description="Rate limit exceeded",
    text_template="[{timestamp}] RATE_LIMIT: {client} exceeded {limit_type} ({current}/{max} in {window}s)",
)
class TechnicalRateLimitGenerator(BaseLogGenerator):
    """Generates rate limit log entries."""

    LIMIT_TYPES = [
        ("requests_per_second", 100, 1),
        ("logins_per_minute", 5, 60),
        ("chat_messages_per_minute", 30, 60),
        ("trade_requests_per_minute", 10, 60),
        ("auction_listings_per_hour", 50, 3600),
        ("api_calls_per_minute", 60, 60),
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        limit = random.choice(self.LIMIT_TYPES)
        current = limit[1] + random.randint(1, 50)

        return {
            "client": f"{generate_ip_address()}:{random.randint(1024, 65535)}",
            "session_id": generate_session_id(),
            "limit_type": limit[0],
            "current": current,
            "max": limit[1],
            "window": limit[2],
            "action": random.choice(["throttled", "blocked", "warned"]),
        }


@register_log_type(
    name="technical.queue_depth",
    category=LogCategory.TECHNICAL,
    severity=LogSeverity.INFO,
    recurrence=RecurrencePattern.NORMAL,
    description="Queue metrics",
    text_template="[{timestamp}] QUEUE: {queue_name} depth={depth}, processed={processed}/s, avg_wait={avg_wait}ms",
)
class TechnicalQueueDepthGenerator(BaseLogGenerator):
    """Generates queue depth log entries."""

    QUEUES = [
        "login_queue", "world_update", "combat_events", "chat_messages",
        "mail_delivery", "auction_updates", "guild_updates", "save_queue",
    ]

    def _generate_data(self, **kwargs: Any) -> Dict[str, Any]:
        depth = random.randint(0, 10000)
        # High depth = lower processing rate
        processed = max(1, int(1000 / max(1, depth / 100)))

        return {
            "queue_name": random.choice(self.QUEUES),
            "depth": depth,
            "processed": processed,
            "avg_wait": random.randint(1, 1000) if depth > 0 else 0,
            "max_depth": 10000,
            "workers": random.randint(1, 16),
        }
