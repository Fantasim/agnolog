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
        local thermal_level = ctx.random.choice({"nominal", "moderate", "heavy", "critical"})
        local level_severity = (thermal_level == "critical" or thermal_level == "heavy") and "Error" or "Default"
        
        return {
            process = "kernel",
            pid = 0,
            level = level_severity,
            subsystem = "com.apple.kernel",
            category = "thermal",
            thermal_level = thermal_level,
            cpu_temp = ctx.random.int(40, 100),
            gpu_temp = ctx.random.int(35, 95)
        }
    end
}
