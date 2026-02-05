-- Security Logoff Generator (Event ID 551)
-- Generates user initiated logoff events

return {
    metadata = {
        name = "security.logoff",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "User initiated logoff",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Logon/Logoff\nEvent ID: 551\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nUser initiated logoff:\n  User Name: {username}\n  Domain: {domain}\n  Logon ID: ({logon_id_high}, {logon_id_low})",
        tags = {"security", "logoff", "audit"},
        merge_groups = {"logon_events"}
    },

    generate = function(ctx, args)
        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999))
        }
    end
}
