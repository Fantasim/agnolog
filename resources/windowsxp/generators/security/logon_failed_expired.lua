-- Security Logon Failed Expired Generator (Event ID 532)
-- Generates logon failure - user account has expired

return {
    metadata = {
        name = "security.logon_failed_expired",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Logon failure - The specified user account has expired",
        text_template = "Event Type: Failure Audit\nEvent Source: Security\nEvent Category: Logon/Logoff\nEvent ID: 532\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nLogon Failure:\n  Reason: The specified user account has expired\n  User Name: {username}\n  Domain: {domain}\n  Logon Type: {logon_type}\n  Logon Process: {logon_process}\n  Authentication Package: {auth_package}\n  Workstation Name: {workstation}\n  Status code: 0xC0000193\n  Substatus code: 0x0",
        tags = {"security", "logon", "audit", "failure", "expired"},
        merge_groups = {"logon_events"}
    },

    generate = function(ctx, args)
        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            logon_type = ctx.random.choice({2, 3}),
            logon_process = "User32",
            auth_package = "Negotiate",
            workstation = ctx.gen.windows_computer()
        }
    end
}
