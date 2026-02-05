-- Security Password Change Generator (Event ID 627)
-- Generates password change attempted events

return {
    metadata = {
        name = "security.password_change",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Password change attempted",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Account Management\nEvent ID: 627\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nChange Password Attempt:\n  Target Account Name: {username}\n  Target Domain: {domain}\n  Target Account ID: {account_sid}\n  Caller User Name: {username}\n  Caller Domain: {domain}\n  Caller Logon ID: ({logon_id_high}, {logon_id_low})\n  Privileges: -",
        tags = {"security", "password", "change", "audit"},
        merge_groups = {"account_management"}
    },

    generate = function(ctx, args)
        local username = ctx.gen.windows_username()
        local domain = ctx.gen.windows_domain()

        return {
            username = username,
            domain = domain,
            computer = ctx.gen.windows_computer(),
            account_sid = ctx.gen.sid(),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999))
        }
    end
}
