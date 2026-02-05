-- Security System Startup Generator (Event ID 512)
-- Generates Windows NT starting up events

return {
    metadata = {
        name = "security.security_startup",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "RARE",
        description = "Windows NT is starting up",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: System Event\nEvent ID: 512\nUser: NT AUTHORITY\\SYSTEM\nComputer: {computer}\nDescription:\nWindows NT is starting up.",
        tags = {"security", "startup", "system", "audit"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer()
        }
    end
}
