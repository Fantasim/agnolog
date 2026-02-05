-- System Sleep Generator
-- Generates system entering sleep log entries

return {
    metadata = {
        name = "system.sleep",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "System entering sleep",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: System entering sleep - {sleep_reason}",
        tags = {"system", "power", "sleep"},
        merge_groups = {"power_events"}
    },

    generate = function(ctx, args)
        local sleep_reasons = ctx.data.system.power_states.sleep_reasons or {"User Idle", "Lid Closed"}

        return {
            process = "powerd",
            pid = ctx.random.int(50, 200),
            level = "Default",
            subsystem = "com.apple.powerd",
            category = "power",
            sleep_reason = ctx.random.choice(sleep_reasons),
            battery_level = ctx.random.int(10, 100),
            idle_time_sec = ctx.random.int(300, 3600),
            sleep_type = ctx.random.choice({"Normal Sleep", "Safe Sleep", "Deep Sleep", "Standby"})
        }
    end
}
