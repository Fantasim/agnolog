return {
    metadata = {
        name = "technical.connection_timeout",
        category = "TECHNICAL",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Connection timeout occurred",
        text_template = "[{timestamp}] TIMEOUT: {service} connection timeout after {duration_ms}ms",
        tags = {"technical", "timeout", "connection"},
        merge_groups = {"errors"}
    },
    generate = function(ctx, args)
        local services = {
            "database",
            "redis_cache",
            "game_engine",
            "matchmaking_service",
            "authentication_service",
            "rating_service"
        }

        return {
            service = ctx.random.choice(services),
            duration_ms = ctx.random.int(5000, 30000),
            timeout_threshold_ms = ctx.random.choice({5000, 10000, 30000}),
            retry_attempted = ctx.random.float(0, 1) < 0.8,
            retry_count = ctx.random.int(0, 3),
            eventual_success = ctx.random.float(0, 1) < 0.6
        }
    end
}
