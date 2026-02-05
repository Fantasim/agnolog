return {
    metadata = {
        name = "security.login_failed",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "FREQUENT",
        description = "Failed login attempt",
        text_template = "[{timestamp}] LOGIN_FAILED: {username} from {ip_address} - {reason}",
        tags = {"security", "login", "failed"},
        merge_groups = {"security_events"}
    },
    generate = function(ctx, args)
        local reasons = {
            "invalid_password",
            "invalid_username",
            "account_locked",
            "two_factor_failed",
            "ip_blocked"
        }

        return {
            username = ctx.gen.player_name(),
            ip_address = ctx.gen.ip_address(),
            reason = ctx.random.choice(reasons),
            attempt_number = ctx.random.int(1, 10),
            user_agent = ctx.random.choice({"Chrome", "Firefox", "Safari", "Mobile App"}),
            country = ctx.random.choice({"US", "RU", "IN", "CN", "DE"})
        }
    end
}
