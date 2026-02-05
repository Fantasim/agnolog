return {
    metadata = {
        name = "server.restart",
        category = "SERVER",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Server restarted",
        text_template = "[{timestamp}] RESTART: {server_id} restarted - {reason}",
        tags = {"server", "restart"},
        merge_groups = {"server_events"}
    },
    generate = function(ctx, args)
        local reasons = {
            "scheduled_restart",
            "config_change",
            "memory_leak",
            "crash_recovery",
            "performance_degradation",
            "security_update"
        }

        return {
            server_id = ctx.random.choice({"game-server-01", "game-server-02", "api-server-01", "cache-server-01"}),
            reason = ctx.random.choice(reasons),
            uptime_hours = ctx.random.int(1, 720),
            games_migrated = ctx.random.int(0, 500),
            restart_duration_seconds = ctx.random.int(30, 300),
            graceful_shutdown = ctx.random.float(0, 1) < 0.85
        }
    end
}
