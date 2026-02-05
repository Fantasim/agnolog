-- System EventLog Started Generator (Event ID 6005)
-- Generates Event log service was started

return {
    metadata = {
        name = "system.eventlog_started",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "The Event log service was started",
        text_template = "Event Type: Information\nEvent Source: EventLog\nEvent Category: None\nEvent ID: 6005\nComputer: {computer}\nDescription:\nThe Event log service was started.",
        tags = {"system", "eventlog", "service", "lifecycle"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer()
        }
    end
}
