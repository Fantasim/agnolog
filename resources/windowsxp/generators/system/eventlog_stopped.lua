-- System EventLog Stopped Generator (Event ID 6006)
-- Generates Event log service was stopped

return {
    metadata = {
        name = "system.eventlog_stopped",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "The Event log service was stopped",
        text_template = "Event Type: Information\nEvent Source: EventLog\nEvent Category: None\nEvent ID: 6006\nComputer: {computer}\nDescription:\nThe Event log service was stopped.",
        tags = {"system", "eventlog", "service", "lifecycle"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer()
        }
    end
}
