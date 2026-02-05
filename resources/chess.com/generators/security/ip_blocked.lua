return {
    metadata = {
        name = "security.ip_blocked",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "IP address blocked",
        text_template = "[{timestamp}] IP_BLOCKED: {ip_address} blocked - {reason}",
        tags = {"security", "ip", "block"},
        merge_groups = {"security_actions"}
    },
    generate = function(ctx, args)
        local reasons = {
            "too_many_failed_logins",
            "ddos_attempt",
            "bot_detected",
            "vpn_proxy",
            "known_attacker",
            "abuse_detected"
        }

        return {
            ip_address = ctx.gen.ip_address(),
            reason = ctx.random.choice(reasons),
            country = ctx.random.choice({"US", "RU", "CN", "IN", "BR", "VN"}),
            failed_attempts = ctx.random.int(5, 50),
            block_duration_hours = ctx.random.choice({1, 6, 24, 168, 720}),
            affected_accounts = ctx.random.int(1, 10)
        }
    end
}
