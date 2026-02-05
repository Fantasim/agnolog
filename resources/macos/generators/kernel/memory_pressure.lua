return {
    metadata = {
        name = "kernel.memory_pressure",
        category = "KERNEL",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Memory pressure event",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: Memory pressure level {pressure_level} (available: {available_mb}MB)",
        tags = {"kernel", "memory", "pressure"},
        merge_groups = {"memory_events"}
    },
    generate = function(ctx, args)
        local levels = {"normal", "warning", "critical", "urgent"}
        local level = ctx.random.choice(levels)
        local available = level == "normal" and ctx.random.int(2048, 8192) or
                         level == "warning" and ctx.random.int(512, 2048) or
                         level == "critical" and ctx.random.int(128, 512) or
                         ctx.random.int(0, 128)
        return {
            process = "kernel",
            pid = 0,
            level = level == "critical" or level == "urgent" and "Error" or "Default",
            subsystem = "com.apple.kernel",
            category = "memory",
            pressure_level = level,
            available_mb = available,
            free_pages = available * 256
        }
    end
}
