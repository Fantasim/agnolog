return {
    metadata = {
        name = "security.account_unlocked",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Locked account unlocked",
        text_template = "[{timestamp}] UNLOCKED: {username} account unlocked - {reason}",
        tags = {"security", "unlock", "recovery"},
        merge_groups = {"security_actions"}
    },
    generate = function(ctx, args)
        local reasons = {
            "password_reset_completed",
            "support_ticket_resolved",
            "ban_expired",
            "appeal_approved",
            "identity_verified"
        }

        return {
            username = ctx.gen.player_name(),
            reason = ctx.random.choice(reasons),
            locked_duration_hours = ctx.random.int(1, 720),
            unlocked_by = ctx.random.choice({"user", "support", "automated"}),
            security_checks_passed = ctx.random.int(1, 3)
        }
    end
}
