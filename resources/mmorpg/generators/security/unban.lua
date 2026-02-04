-- Admin Unban Generator

return {
    metadata = {
        name = "admin.unban",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Player unbanned",
        text_template = "[{timestamp}] UNBAN: {admin} unbanned {target} (reason: {reason})",
        tags = {"security", "admin", "unban"}
    },

    generate = function(ctx, args)
        local reasons = {
            "appeal_approved", "ban_expired", "false_positive",
            "admin_error", "policy_change"
        }

        local admin_names = {"Alpha", "Beta", "Gamma", "Delta"}

        return {
            admin = "GM_" .. ctx.random.choice(admin_names),
            target = args.target or ctx.gen.player_name(),
            reason = ctx.random.choice(reasons),
            original_ban_id = "BAN-" .. ctx.random.int(10000, 99999)
        }
    end
}
