-- Security Login Failed Generator
-- Generates failed login attempt log entries

return {
    metadata = {
        name = "security.login_failed",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Failed login attempt",
        text_template = "[{timestamp}] LOGIN FAILED: {username} from {ip} reason: {reason}",
        tags = {"security", "auth", "failed"},
        merge_groups = {"auth_failures"}
    },

    reasons = {
        "invalid_password",
        "account_not_found",
        "account_banned",
        "account_locked",
        "ip_blocked",
        "too_many_attempts",
        "invalid_token",
        "session_expired"
    },

    generate = function(ctx, args)
        local reasons = {
            "invalid_password",
            "account_not_found",
            "account_banned",
            "account_locked",
            "ip_blocked",
            "too_many_attempts"
        }

        local ip = args.ip or ctx.gen.ip_address()

        return {
            username = args.username or ctx.gen.player_name(),
            ip = ip,
            reason = ctx.random.choice(reasons),
            attempt_count = ctx.random.int(1, 10),
            geo_location = ctx.random.choice({"US", "EU", "CN", "RU", "BR", "KR", "JP", "AU"}),
            user_agent = "GameClient/" .. string.format("%d.%d", ctx.random.int(1, 5), ctx.random.int(0, 20))
        }
    end
}
