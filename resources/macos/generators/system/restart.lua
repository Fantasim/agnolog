-- System Restart Generator
-- Generates system restart log entries

return {
    metadata = {
        name = "system.restart",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "System restart initiated",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: System restart initiated - {reason}",
        tags = {"system", "restart", "power"},
        merge_groups = {"power_events"}
    },

    generate = function(ctx, args)
        return {
            process = "loginwindow",
            pid = ctx.random.int(100, 500),
            level = "Notice",
            subsystem = "com.apple.loginwindow",
            category = "power",
            reason = ctx.random.choice({
                "Software update required",
                "User requested",
                "System update",
                "Kernel extension update",
                "Configuration change"
            }),
            pending_updates = ctx.random.int(0, 5)
        }
    end
}
