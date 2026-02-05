-- System Shutdown Complete Generator
-- Generates shutdown completion log entries

return {
    metadata = {
        name = "system.shutdown_complete",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "Shutdown completed",
        text_template = "[{timestamp}] systemd[1]: Reached target {target}",
        tags = {"shutdown", "systemd", "system"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        local targets = {
            "Shutdown",
            "Power-Off",
            "Reboot",
            "Final Step"
        }

        return {
            target = ctx.random.choice(targets),
            uptime_seconds = ctx.random.int(60, 2592000)
        }
    end
}
