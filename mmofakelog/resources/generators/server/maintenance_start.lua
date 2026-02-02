-- Server Maintenance Start Generator

return {
    metadata = {
        name = "server.maintenance_start",
        category = "SERVER",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Scheduled maintenance starting",
        text_template = "[{timestamp}] MAINTENANCE_START: Scheduled maintenance begun (est. {duration} min)",
        tags = {"server", "maintenance", "downtime"}
    },

    generate = function(ctx, args)
        local durations = {15, 30, 60, 120, 240, 480}
        local reasons = {"weekly_reset", "patch", "hotfix", "emergency", "hardware"}

        return {
            duration = ctx.random.choice(durations),
            reason = ctx.random.choice(reasons),
            affected_realms = ctx.random.int(1, 50)
        }
    end
}
