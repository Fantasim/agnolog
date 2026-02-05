-- Security Account Disabled Generator (Event ID 629)
-- Generates user account disabled events

return {
    metadata = {
        name = "security.account_disabled",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "RARE",
        description = "User account disabled",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Account Management\nEvent ID: 629\nUser: {domain}\\{admin_username}\nComputer: {computer}\nDescription:\nUser Account Disabled:\n  Target Account Name: {target_username}\n  Target Domain: {domain}\n  Target Account ID: {account_sid}\n  Caller User Name: {admin_username}\n  Caller Domain: {domain}\n  Caller Logon ID: ({logon_id_high}, {logon_id_low})\n  Privileges: -",
        tags = {"security", "account", "disabled", "audit"},
        merge_groups = {"account_management"}
    },

    generate = function(ctx, args)
        return {
            admin_username = ctx.gen.windows_username(),
            target_username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            account_sid = ctx.gen.sid(),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999))
        }
    end
}
