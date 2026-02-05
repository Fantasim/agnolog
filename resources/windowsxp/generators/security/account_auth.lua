-- Security Account Authentication Generator (Event ID 680)
-- Generates account authentication events

return {
    metadata = {
        name = "security.account_auth",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Account used for authentication",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Account Logon\nEvent ID: 680\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nAccount Used for Authentication:\n  Logon Account: {username}\n  Source Workstation: {workstation}\n  Error Code: 0x0",
        tags = {"security", "authentication", "audit"},
        merge_groups = {"logon_events"}
    },

    generate = function(ctx, args)
        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            workstation = ctx.gen.windows_computer()
        }
    end
}
