-- Security Account Locked Generator (Event ID 539)
-- Generates logon failure - account locked out

return {
    metadata = {
        name = "security.account_locked",
        category = "SECURITY",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Logon failure - Account locked out",
        text_template = "Event Type: Failure Audit\nEvent Source: Security\nEvent Category: Logon/Logoff\nEvent ID: 539\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nLogon Failure:\n  Reason: Account locked out\n  User Name: {username}\n  Domain: {domain}\n  Logon Type: {logon_type}\n  Logon Process: {logon_process}\n  Authentication Package: {auth_package}\n  Workstation Name: {workstation}\n  Status code: 0xC0000234\n  Substatus code: 0x0",
        tags = {"security", "logon", "audit", "failure", "locked"},
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
