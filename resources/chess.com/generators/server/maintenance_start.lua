return {
    metadata = {
        name = "server.maintenance_start",
        category = "SERVER",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Server maintenance started",
        text_template = "[{timestamp}] MAINTENANCE_START: {server_id} entering maintenance - estimated {duration_minutes}min",
        tags = {"server", "maintenance"},
        merge_groups = {"server_events"}
    },
    generate = function(ctx, args)
        local reasons = {
            "scheduled_update",
            "security_patch",
            "database_optimization",
            "hardware_upgrade",
            "emergency_fix"
        }

        return {
            server_id = ctx.random.choice({"game-server-01", "game-server-02", "api-server-01", "db-server-01"}),
            reason = ctx.random.choice(reasons),
            duration_minutes = ctx.random.int(30, 180),
            scheduled = ctx.random.float(0, 1) < 0.8,
            affected_users = ctx.random.int(1000, 50000),
            notification_sent = true
        }
    end
}
