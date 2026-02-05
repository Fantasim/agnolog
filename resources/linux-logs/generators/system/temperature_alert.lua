-- Temperature Alert Generator
-- Generates temperature warning log entries

return {
    metadata = {
        name = "system.temperature_alert",
        category = "SYSTEM",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Temperature warning",
        text_template = "[{timestamp}] kernel: thermal thermal_zone{zone}: temperature {temp}C above threshold, trip_point={trip_point}",
        tags = {"temperature", "thermal", "sensor"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local limits = ctx.data.constants.system_limits.cpu or {}

        return {
            zone = ctx.random.int(0, 5),
            temp = ctx.random.int(limits.temperature_warning or 75, limits.temperature_critical or 90),
            trip_point = ctx.random.int(0, 3)
        }
    end
}
