-- System Event Log Full Generator (Event ID 1105)
-- Generates event log full warning

return {
    metadata = {
        name = "system.eventlog_full",
        category = "SYSTEM",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Event log full",
        text_template = "Event Type: Warning\nEvent Source: EventLog\nEvent Category: None\nEvent ID: 1105\nComputer: {computer}\nDescription:\nThe {log_name} log file is full.",
        tags = {"system", "eventlog", "full", "warning"},
        merge_groups = {"eventlog_management"}
    },

    generate = function(ctx, args)
        local log_names = {"Application", "Security", "System"}

        return {
            computer = ctx.gen.windows_computer(),
            log_name = ctx.random.choice(log_names)
        }
    end
}
