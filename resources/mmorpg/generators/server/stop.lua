-- Server Stop Generator

return {
    metadata = {
        name = "server.stop",
        category = "SERVER",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Server shutdown",
        text_template = "[{timestamp}] SERVER_STOP: {server_id} shutdown (reason: {reason}, uptime: {uptime_hours}h)",
        tags = {"server", "lifecycle", "shutdown"},
        merge_groups = {"server_state"}
    },

    generate = function(ctx, args)
        local reasons = {"scheduled_maintenance", "emergency", "update", "crash_recovery",
            "resource_exhaustion", "admin_command", "hardware_failure"}

        return {
            server_id = args.server_id or ("world-" .. ctx.random.int(1, 10)),
            reason = ctx.random.choice(reasons),
            uptime_hours = ctx.random.int(1, 720),
            players_disconnected = ctx.random.int(0, 5000),
            graceful = ctx.random.float() > 0.1
        }
    end
}
