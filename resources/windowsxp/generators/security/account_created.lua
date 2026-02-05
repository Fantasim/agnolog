-- Security Account Created Generator (Event ID 624)
-- Generates user account created events

return {
    metadata = {
        name = "security.account_created",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "RARE",
        description = "User account created",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Account Management\nEvent ID: 624\nUser: {domain}\\{admin_username}\nComputer: {computer}\nDescription:\nUser Account Created:\n  New Account Name: {new_username}\n  New Domain: {domain}\n  New Account ID: {account_sid}\n  Caller User Name: {admin_username}\n  Caller Domain: {domain}\n  Caller Logon ID: ({logon_id_high}, {logon_id_low})\n  Privileges: -",
        tags = {"security", "account", "created", "audit"},
        merge_groups = {"account_management"}
    },

    generate = function(ctx, args)
        return {
            admin_username = ctx.gen.windows_username(),
            new_username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            account_sid = ctx.gen.sid(),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999))
        }
    end
}
