-- Security Logon Failed Workstation Generator (Event ID 533)
-- Generates logon failure - user not allowed to logon at this computer

return {
    metadata = {
        name = "security.logon_failed_workstation",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Logon failure - User not allowed to logon at this computer",
        text_template = "Event Type: Failure Audit\nEvent Source: Security\nEvent Category: Logon/Logoff\nEvent ID: 533\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nLogon Failure:\n  Reason: User not allowed to logon at this computer\n  User Name: {username}\n  Domain: {domain}\n  Logon Type: {logon_type}\n  Logon Process: {logon_process}\n  Authentication Package: {auth_package}\n  Workstation Name: {workstation}\n  Status code: 0xC0000070\n  Substatus code: 0x0",
        tags = {"security", "logon", "audit", "failure", "workstation"},
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
