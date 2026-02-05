-- Security Logon Failed Type Generator (Event ID 534)
-- Generates logon failure - user has not been granted requested logon type

return {
    metadata = {
        name = "security.logon_failed_type",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Logon failure - The user has not been granted the requested logon type",
        text_template = "Event Type: Failure Audit\nEvent Source: Security\nEvent Category: Logon/Logoff\nEvent ID: 534\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nLogon Failure:\n  Reason: The user has not been granted the requested logon type at this computer\n  User Name: {username}\n  Domain: {domain}\n  Logon Type: {logon_type}\n  Logon Process: {logon_process}\n  Authentication Package: {auth_package}\n  Workstation Name: {workstation}\n  Status code: 0xC000015B\n  Substatus code: 0x0",
        tags = {"security", "logon", "audit", "failure", "type"},
        merge_groups = {"logon_events"}
    },

    generate = function(ctx, args)
        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            logon_type = ctx.random.choice({5, 7, 10}),
            logon_process = "User32",
            auth_package = "Negotiate",
            workstation = ctx.gen.windows_computer()
        }
    end
}
