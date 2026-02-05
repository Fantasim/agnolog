-- Security Policy Change Generator (Event ID 612)
-- Generates audit policy change events

return {
    metadata = {
        name = "security.policy_change",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Audit policy change",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Policy Change\nEvent ID: 612\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nAudit Policy Change:\n  New Policy: {policy}\n  Success: {success}\n  Failure: {failure}\n  User: {username}\n  Domain: {domain}\n  Logon ID: ({logon_id_high}, {logon_id_low})",
        tags = {"security", "policy", "change", "audit"},
        merge_groups = {"policy_changes"}
    },

    generate = function(ctx, args)
        local policies = {
            "Logon/Logoff",
            "Object Access",
            "Privilege Use",
            "Account Management",
            "Policy Change",
            "System Events"
        }

        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            policy = ctx.random.choice(policies),
            success = ctx.random.choice({"Enabled", "Disabled"}),
            failure = ctx.random.choice({"Enabled", "Disabled"}),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999))
        }
    end
}
