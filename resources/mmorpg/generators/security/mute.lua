-- Admin Mute Generator

return {
    metadata = {
        name = "admin.mute",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Player muted",
        text_template = "[{timestamp}] MUTE: {admin} muted {target} for {duration} (reason: {reason})",
        tags = {"security", "admin", "mute"}
    },

    generate = function(ctx, args)
        local reasons = {
            "spam", "harassment", "advertising", "profanity",
            "inappropriate_content", "impersonation"
        }

        local admin_names = {"Alpha", "Beta", "Gamma", "Delta"}
        local duration_min = ctx.random.choice({5, 15, 30, 60, 180, 1440})
        local channels = {"all", "say", "trade", "whisper"}

        return {
            admin = "GM_" .. ctx.random.choice(admin_names),
            target = args.target or ctx.gen.character_name(),
            duration = duration_min .. "min",
            duration_minutes = duration_min,
            reason = ctx.random.choice(reasons),
            channel = ctx.random.choice(channels)
        }
    end
}
