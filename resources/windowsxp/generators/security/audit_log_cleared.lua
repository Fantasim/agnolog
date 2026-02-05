-- Security Audit Log Cleared Generator (Event ID 517)
-- Generates audit log cleared events (rare, critical)

return {
    metadata = {
        name = "security.audit_log_cleared",
        category = "SECURITY",
        severity = "CRITICAL",
        recurrence = "RARE",
        description = "The audit log was cleared",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: System Event\nEvent ID: 517\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nThe audit log was cleared.\n  Primary User Name: {username}\n  Primary Domain: {domain}\n  Primary Logon ID: ({logon_id_high}, {logon_id_low})\n  Client User Name: {client_user}\n  Client Domain: {client_domain}\n  Client Logon ID: ({client_logon_id_high}, {client_logon_id_low})",
        tags = {"security", "audit", "cleared", "critical"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999)),
            client_user = ctx.gen.windows_username(),
            client_domain = ctx.gen.windows_domain(),
            client_logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            client_logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999))
        }
    end
}
