return {
    metadata = {
        name = "security.account_closed",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Account closed by user or admin",
        text_template = "[{timestamp}] ACCOUNT_CLOSED: {username} account closed - {reason}",
        tags = {"security", "account", "closure"},
        merge_groups = {"security_actions"}
    },
    generate = function(ctx, args)
        local reasons = {
            "user_request",
            "terms_violation",
            "duplicate_account",
            "inactivity",
            "payment_fraud"
        }

        return {
            username = ctx.gen.player_name(),
            reason = ctx.random.choice(reasons),
            account_age_days = ctx.random.int(1, 3650),
            games_played = ctx.random.int(0, 10000),
            initiated_by = ctx.random.choice({"user", "admin", "automated"}),
            data_retained = ctx.random.float(0, 1) < 0.3
        }
    end
}
