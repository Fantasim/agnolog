-- System Shutdown Generator
-- Generates system shutdown log entries

return {
    metadata = {
        name = "system.shutdown",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "System shutdown initiated",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: System shutdown initiated by {initiator}",
        tags = {"system", "shutdown", "power"},
        merge_groups = {"power_events"}
    },

    generate = function(ctx, args)
        local initiators = {"user", "system", "softwareupdated", "installer", "shutdown command"}

        return {
            process = "loginwindow",
            pid = ctx.random.int(100, 500),
            level = "Notice",
            subsystem = "com.apple.loginwindow",
            category = "power",
            initiator = ctx.random.choice(initiators),
            reason = ctx.random.choice({"User requested", "Software update", "Low battery", "Thermal event"}),
            grace_period = ctx.random.choice({0, 60, 300})
        }
    end
}
