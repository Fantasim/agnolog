-- System Event 6006: The Event log service was stopped
-- Indicates system shutdown

return {
    metadata = {
        name = "system.system_shutdown",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "The Event log service was stopped",
        text_template = "[{timestamp}] Event {event_id}: {description}",
        tags = {"system", "shutdown", "lifecycle"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        return {
            event_id = 6006,
            provider_name = "EventLog",
            channel = "System",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "None",
            keywords = "0x80000000000000",  -- Classic

            description = "The Event log service was stopped."
        }
    end
}
