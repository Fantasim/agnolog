-- System Timezone Changed Generator
-- Generates timezone change log entries

return {
    metadata = {
        name = "system.timezone_changed",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "System timezone changed",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Timezone changed from {old_tz} to {new_tz}",
        tags = {"system", "timezone", "config"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local timezones = {
            "America/Los_Angeles",
            "America/New_York",
            "America/Chicago",
            "America/Denver",
            "Europe/London",
            "Europe/Paris",
            "Asia/Tokyo",
            "Australia/Sydney"
        }

        local old_tz = ctx.random.choice(timezones)
        local new_tz = ctx.random.choice(timezones)

        return {
            process = "systempreferences",
            pid = ctx.random.int(1000, 65535),
            level = "Notice",
            subsystem = "com.apple.systempreferences",
            category = "timezone",
            old_tz = old_tz,
            new_tz = new_tz,
            auto_detect = ctx.random.choice({true, false})
        }
    end
}
