-- Admin Kick Generator

return {
    metadata = {
        name = "admin.kick",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Player kicked",
        text_template = "[{timestamp}] KICK: {admin} kicked {target} (reason: {reason})",
        tags = {"security", "admin", "kick"},
        merge_groups = {"gm_actions"}
    },

    generate = function(ctx, args)
        local reasons = {
            "afk_abuse", "griefing", "harassment", "bug_abuse",
            "requested", "server_cleanup", "investigation"
        }

        local admin_names = {"Alpha", "Beta", "Gamma", "Delta"}

        local zones = {"Stormwind", "Orgrimmar", "Elwynn Forest"}
        if ctx.data.world and ctx.data.world.cities then
            zones = {}
            for _, city in ipairs(ctx.data.world.cities) do
                table.insert(zones, city.name or city)
            end
        end

        return {
            admin = "GM_" .. ctx.random.choice(admin_names),
            target = args.target or ctx.gen.character_name(),
            reason = ctx.random.choice(reasons),
            zone = ctx.random.choice(zones)
        }
    end
}
