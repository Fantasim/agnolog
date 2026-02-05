return {
    metadata = {
        name = "security.account_banned",
        category = "SECURITY",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Account banned",
        text_template = "[{timestamp}] BANNED: {username} banned for {duration} days - {reason}",
        tags = {"security", "ban", "punishment"},
        merge_groups = {"security_actions"}
    },
    generate = function(ctx, args)
        local reasons = ctx.data.constants.security.ban_reasons

        return {
            username = ctx.gen.player_name(),
            ban_id = ctx.gen.uuid(),
            reason = ctx.random.choice(reasons),
            duration_days = ctx.random.choice({1, 7, 30, 90, 365, 9999}),  -- 9999 = permanent
            previous_bans = ctx.random.int(0, 3),
            banned_by = ctx.random.choice({"automated_system", "moderator", "admin"}),
            appeal_allowed = ctx.random.float(0, 1) < 0.7
        }
    end
}
