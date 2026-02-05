-- Security System Shutdown Generator (Event ID 513)
-- Generates Windows is shutting down events

return {
    metadata = {
        name = "security.security_shutdown",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "RARE",
        description = "Windows is shutting down",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: System Event\nEvent ID: 513\nUser: NT AUTHORITY\\SYSTEM\nComputer: {computer}\nDescription:\nWindows is shutting down.\nAll logon sessions will be terminated by this shutdown.",
        tags = {"security", "shutdown", "system", "audit"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer()
        }
    end
}
