-- System Shutdown Start Generator
-- Generates shutdown initiation log entries

return {
    metadata = {
        name = "system.shutdown_start",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "Shutdown initiated",
        text_template = "[{timestamp}] systemd[1]: Stopping {reason}...",
        tags = {"shutdown", "systemd", "system"},
        merge_groups = {"system_lifecycle"}
    },

    reasons = {
        "Default",
        "Reboot",
        "Power-off",
        "Halt"
    },

    generate = function(ctx, args)
        local reasons = {
            "Default",
            "Reboot",
            "Power-off",
            "Halt"
        }

        return {
            reason = ctx.random.choice(reasons),
            initiated_by = ctx.gen.player_name()
        }
    end
}
