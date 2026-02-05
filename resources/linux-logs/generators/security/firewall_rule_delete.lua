-- Firewall Rule Delete Generator
-- Generates firewall rule deletion log entries

return {
    metadata = {
        name = "security.firewall_rule_delete",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Firewall rule deleted",
        text_template = "[{timestamp}] iptables[{pid}]: Deleted rule: {rule}",
        tags = {"firewall", "iptables"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local rules = {
            "ACCEPT tcp -- anywhere anywhere tcp dpt:telnet",
            "ACCEPT tcp -- anywhere anywhere tcp dpt:ftp",
            "DROP all -- {ip} anywhere"
        }

        return {
            pid = ctx.random.int(100, 32768),
            rule = ctx.random.choice(rules),
            ip = ctx.gen.ip_address()
        }
    end
}
