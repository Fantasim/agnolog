-- Security Account Deleted Generator (Event ID 630)
-- Generates user account deleted events

return {
    metadata = {
        name = "security.account_deleted",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "RARE",
        description = "User account deleted",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Account Management\nEvent ID: 630\nUser: {domain}\\{admin_username}\nComputer: {computer}\nDescription:\nUser Account Deleted:\n  Target Account Name: {deleted_username}\n  Target Domain: {domain}\n  Target Account ID: {account_sid}\n  Caller User Name: {admin_username}\n  Caller Domain: {domain}\n  Caller Logon ID: ({logon_id_high}, {logon_id_low})\n  Privileges: -",
        tags = {"security", "account", "deleted", "audit"},
        merge_groups = {"account_management"}
    },

    generate = function(ctx, args)
        return {
            admin_username = ctx.gen.windows_username(),
            deleted_username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            account_sid = ctx.gen.sid(),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999))
        }
    end
}
