return {
    metadata = {
        name = "security.password_changed",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "User changed password",
        text_template = "[{timestamp}] PASSWORD_CHANGE: {username} changed password from {ip_address}",
        tags = {"security", "password", "account"},
        merge_groups = {"security_events"}
    },
    generate = function(ctx, args)
        return {
            username = ctx.gen.player_name(),
            ip_address = ctx.gen.ip_address(),
            changed_via = ctx.random.choice({"settings_page", "password_reset", "security_alert"}),
            previous_password_age_days = ctx.random.int(30, 730),
            notification_sent = true
        }
    end
}
