-- System Shutdown Initiate Generator (Event ID 1074)
-- Generates system shutdown initiated by user

return {
    metadata = {
        name = "system.shutdown_initiate",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "System shutdown initiated by user",
        text_template = "Event Type: Information\nEvent Source: USER32\nEvent Category: None\nEvent ID: 1074\nComputer: {computer}\nDescription:\nThe process {process} has initiated the {action} of computer {computer} on behalf of user {domain}\\{username} for the following reason: {reason}\n  Reason Code: {reason_code}\n  Shutdown Type: {shutdown_type}\n  Comment: ",
        tags = {"system", "shutdown", "user", "lifecycle"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        local processes = {
            "C:\\WINDOWS\\system32\\winlogon.exe",
            "C:\\WINDOWS\\system32\\shutdown.exe",
            "C:\\WINDOWS\\Explorer.EXE"
        }

        local actions = {"restart", "shutdown"}
        local reasons = {
            "Operating System: Upgrade (Planned)",
            "Application: Maintenance (Planned)",
            "Other (Unplanned)",
            "Hardware: Maintenance (Unplanned)"
        }

        local action = ctx.random.choice(actions)

        return {
            computer = ctx.gen.windows_computer(),
            process = ctx.random.choice(processes),
            action = action,
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            reason = ctx.random.choice(reasons),
            reason_code = string.format("0x%x%06x",
                ctx.random.choice({0x80, 0x84}),
                ctx.random.int(0, 999999)),
            shutdown_type = action
        }
    end
}
