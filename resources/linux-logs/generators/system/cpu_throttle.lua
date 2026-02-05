-- CPU Throttle Generator
-- Generates CPU throttling log entries

return {
    metadata = {
        name = "system.cpu_throttle",
        category = "SYSTEM",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "CPU throttling activated",
        text_template = "[{timestamp}] kernel: CPU{cpu_id}: Package temperature above threshold, cpu clock throttled (total events = {event_count})",
        tags = {"cpu", "temperature", "throttle"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local limits = ctx.data.constants.system_limits.cpu or {}

        return {
            cpu_id = ctx.random.int(0, (limits.typical_cores or 8) - 1),
            event_count = ctx.random.int(1, 1000),
            temperature = ctx.random.int(limits.temperature_warning or 80, limits.temperature_critical or 90)
        }
    end
}
