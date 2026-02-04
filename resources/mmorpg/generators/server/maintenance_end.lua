-- Server Maintenance End Generator

return {
    metadata = {
        name = "server.maintenance_end",
        category = "SERVER",
        severity = "INFO",
        recurrence = "RARE",
        description = "Maintenance completed",
        text_template = "[{timestamp}] MAINTENANCE_END: Maintenance completed ({actual_duration} min)",
        tags = {"server", "maintenance", "uptime"},
        merge_groups = {"server_state"}
    },

    generate = function(ctx, args)
        return {
            actual_duration = ctx.random.int(10, 300),
            issues_resolved = ctx.random.int(0, 10),
            patches_applied = ctx.random.int(0, 5)
        }
    end
}
