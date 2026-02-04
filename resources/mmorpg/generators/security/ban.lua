-- Admin Ban Generator

return {
    metadata = {
        name = "admin.ban",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Player banned",
        text_template = "[{timestamp}] BAN: {admin} banned {target} for {duration} (reason: {reason})",
        tags = {"security", "admin", "ban"},
        merge_groups = {"gm_actions"}
    },

    generate = function(ctx, args)
        local reasons = {
            "cheating", "harassment", "exploiting", "botting", "gold_selling",
            "account_sharing", "inappropriate_name", "scamming", "hate_speech"
        }

        local admin_names = {"Alpha", "Beta", "Gamma", "Delta"}
        local duration_days = ctx.random.choice({1, 3, 7, 14, 30, 180, 3650})

        local duration_str
        if duration_days >= 3650 then
            duration_str = "permanent"
        else
            duration_str = duration_days .. "d"
        end

        return {
            admin = "GM_" .. ctx.random.choice(admin_names),
            target = args.target or ctx.gen.player_name(),
            duration = duration_str,
            duration_days = duration_days,
            reason = ctx.random.choice(reasons),
            evidence_id = "EVD-" .. ctx.random.int(10000, 99999)
        }
    end
}
