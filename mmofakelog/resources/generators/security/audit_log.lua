-- Security Audit Log Generator

return {
    metadata = {
        name = "security.audit_log",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Security audit trail",
        text_template = "[{timestamp}] AUDIT: {action} by {actor} on {target}",
        tags = {"security", "audit", "trail"}
    },

    generate = function(ctx, args)
        local actions = {
            "password_changed", "email_changed", "2fa_enabled", "2fa_disabled",
            "session_created", "session_terminated", "permissions_modified",
            "character_restored", "gold_adjusted", "item_removed"
        }

        local admin_names = {"Alpha", "Beta", "Gamma"}
        local is_admin = ctx.random.float() < 0.3

        local actor, actor_type
        if is_admin then
            actor = "GM_" .. ctx.random.choice(admin_names)
            actor_type = "admin"
        else
            actor = ctx.gen.player_name()
            actor_type = "player"
        end

        return {
            action = ctx.random.choice(actions),
            actor = actor,
            actor_type = actor_type,
            target = args.target or ctx.gen.player_name(),
            ip = ctx.gen.ip_address(),
            details = {}
        }
    end
}
