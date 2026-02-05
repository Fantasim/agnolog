-- System Event 6005: The Event log service was started
-- Indicates system boot

return {
    metadata = {
        name = "system.system_boot",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "The Event log service was started",
        text_template = "[{timestamp}] Event {event_id}: {description}",
        tags = {"system", "boot", "lifecycle"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        return {
            event_id = 6005,
            provider_name = "EventLog",
            channel = "System",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "None",
            keywords = "0x80000000000000",  -- Classic

            description = "The Event log service was started."
        }
    end
}
