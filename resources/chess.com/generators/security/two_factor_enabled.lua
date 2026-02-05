return {
    metadata = {
        name = "security.two_factor_enabled",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Two-factor authentication enabled",
        text_template = "[{timestamp}] 2FA_ENABLED: {username} enabled two-factor auth via {method}",
        tags = {"security", "2fa", "authentication"},
        merge_groups = {"security_events"}
    },
    generate = function(ctx, args)
        local methods = {
            "authenticator_app",
            "sms",
            "email",
            "hardware_key"
        }

        return {
            username = ctx.gen.player_name(),
            method = ctx.random.choice(methods),
            backup_codes_generated = ctx.random.int(5, 10),
            ip_address = ctx.gen.ip_address()
        }
    end
}
