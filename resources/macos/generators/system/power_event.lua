-- System Power Event Generator
-- Generates power state change log entries

return {
    metadata = {
        name = "system.power_event",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Power state change event",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Power state changed to {power_state}",
        tags = {"system", "power", "battery"},
        merge_groups = {"power_events"}
    },

    generate = function(ctx, args)
        local power_states = ctx.data.system.power_states.power_states or {"Active", "Idle", "Sleep"}

        return {
            process = "powerd",
            pid = ctx.random.int(50, 200),
            level = "Default",
            subsystem = "com.apple.powerd",
            category = "power",
            power_state = ctx.random.choice(power_states),
            battery_level = ctx.random.int(0, 100),
            is_charging = ctx.random.choice({true, false}),
            power_source = ctx.random.choice({"AC Power", "Battery", "UPS"})
        }
    end
}
