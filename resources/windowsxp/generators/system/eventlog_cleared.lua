-- System Event Log Cleared Generator (Event ID 1102)
-- Generates event log cleared events

return {
    metadata = {
        name = "system.eventlog_cleared",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "Event log cleared",
        text_template = "Event Type: Information\nEvent Source: EventLog\nEvent Category: None\nEvent ID: 1102\nComputer: {computer}\nDescription:\nThe {log_name} log file was cleared.\n  Log: {log_name}\n  User: {domain}\\{username}",
        tags = {"system", "eventlog", "cleared"},
        merge_groups = {"eventlog_management"}
    },

    generate = function(ctx, args)
        local log_names = {"Application", "Security", "System"}

        return {
            computer = ctx.gen.windows_computer(),
            log_name = ctx.random.choice(log_names),
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain()
        }
    end
}
