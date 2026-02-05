-- Intrusion Attempt Generator
-- Generates intrusion detection log entries

return {
    metadata = {
        name = "security.intrusion_attempt",
        category = "SECURITY",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Intrusion attempt",
        text_template = "[{timestamp}] snort[{pid}]: ALERT [{signature}] from {src_ip}:{src_port} to {dst_ip}:{dst_port}",
        tags = {"ids", "security", "intrusion"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local signatures = ctx.data.security.attack_patterns.intrusion_signatures or {
            "WEB-ATTACKS directory traversal",
            "SCAN nmap TCP",
            "EXPLOIT SQL injection"
        }

        return {
            pid = ctx.random.int(100, 32768),
            signature = ctx.random.choice(signatures),
            src_ip = ctx.gen.ip_address(),
            src_port = ctx.random.int(1024, 65535),
            dst_ip = ctx.gen.ip_address(),
            dst_port = ctx.random.int(1, 65535)
        }
    end
}
