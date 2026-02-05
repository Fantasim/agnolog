-- System Wake Generator
-- Generates system waking from sleep log entries

return {
    metadata = {
        name = "system.wake",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "System waking from sleep",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: System wake from sleep - {wake_reason}",
        tags = {"system", "power", "wake"},
        merge_groups = {"power_events"}
    },

    generate = function(ctx, args)
        local wake_reasons = ctx.data.system.power_states.wake_reasons or {"User Activity", "Lid Open"}

        return {
            process = "powerd",
            pid = ctx.random.int(50, 200),
            level = "Default",
            subsystem = "com.apple.powerd",
            category = "power",
            wake_reason = ctx.random.choice(wake_reasons),
            sleep_duration_sec = ctx.random.int(60, 28800),
            wake_type = ctx.random.choice({"Full Wake", "Dark Wake", "Maintenance Wake"}),
            battery_level = ctx.random.int(5, 100)
        }
    end
}
