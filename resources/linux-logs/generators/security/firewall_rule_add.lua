-- Firewall Rule Add Generator
-- Generates firewall rule addition log entries

return {
    metadata = {
        name = "security.firewall_rule_add",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Firewall rule added",
        text_template = "[{timestamp}] iptables[{pid}]: Added rule: {rule}",
        tags = {"firewall", "iptables"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local rules = {
            "ACCEPT tcp -- anywhere anywhere tcp dpt:ssh",
            "ACCEPT tcp -- anywhere anywhere tcp dpt:http",
            "ACCEPT tcp -- anywhere anywhere tcp dpt:https",
            "DROP all -- anywhere anywhere"
        }

        return {
            pid = ctx.random.int(100, 32768),
            rule = ctx.random.choice(rules)
        }
    end
}
