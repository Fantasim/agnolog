-- System Thermal Event Generator
-- Generates thermal pressure event log entries

return {
    metadata = {
        name = "system.thermal_event",
        category = "SYSTEM",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Thermal pressure event",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: Thermal pressure level {thermal_level}",
        tags = {"system", "thermal", "temperature"},
        merge_groups = {"power_events"}
    },

    generate = function(ctx, args)
        local thermal_levels = {
            {name = "nominal", severity = "Default"},
            {name = "moderate", severity = "Default"},
            {name = "heavy", severity = "Default"},
            {name = "critical", severity = "Error"}
        }

        local level = ctx.random.weighted(thermal_levels, {0.70, 0.20, 0.08, 0.02})

        return {
            process = "kernel",
            pid = 0,
            level = level.severity,
            subsystem = "com.apple.kernel",
            category = "thermal",
            thermal_level = level.name,
            cpu_temp = ctx.random.int(40, 100),
            gpu_temp = ctx.random.int(35, 95),
            throttling = level.name == "critical" or level.name == "heavy"
        }
    end
}
