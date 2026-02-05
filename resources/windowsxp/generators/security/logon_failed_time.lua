-- Security Logon Failed Time Generator (Event ID 531)
-- Generates logon failure - account currently disabled

return {
    metadata = {
        name = "security.logon_failed_time",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Logon failure - Account currently disabled",
        text_template = "Event Type: Failure Audit\nEvent Source: Security\nEvent Category: Logon/Logoff\nEvent ID: 531\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nLogon Failure:\n  Reason: Account currently disabled\n  User Name: {username}\n  Domain: {domain}\n  Logon Type: {logon_type}\n  Logon Process: {logon_process}\n  Authentication Package: {auth_package}\n  Workstation Name: {workstation}\n  Status code: 0xC0000072\n  Substatus code: 0x0",
        tags = {"security", "logon", "audit", "failure", "disabled"},
        merge_groups = {"logon_events"}
    },

    generate = function(ctx, args)
        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            logon_type = ctx.random.choice({2, 3, 10}),
            logon_process = "User32",
            auth_package = "Negotiate",
            workstation = ctx.gen.windows_computer()
        }
    end
}