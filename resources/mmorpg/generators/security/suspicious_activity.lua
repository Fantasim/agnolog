-- Security Suspicious Activity Generator

return {
    metadata = {
        name = "security.suspicious_activity",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Suspicious activity detected",
        text_template = "[{timestamp}] SUSPICIOUS: {char_name} - {activity_type} (score: {risk_score})",
        tags = {"security", "cheat", "detection"},
        merge_groups = {"security_violations"}
    },

    generate = function(ctx, args)
        local activity_types = {
            "unusual_gold_transfer", "rapid_level_gain", "impossible_movement",
            "automated_behavior", "item_duplication_attempt", "memory_modification",
            "packet_manipulation", "unusual_login_pattern", "multi_accounting"
        }

        local risk_levels = {"low", "medium", "high", "critical"}

        if ctx.data.constants and ctx.data.constants.server then
            local sc = ctx.data.constants.server
            if sc.risk_levels then risk_levels = sc.risk_levels end
        end

        local zones = {"Stormwind", "Orgrimmar", "Elwynn Forest"}
        if ctx.data.world and ctx.data.world.cities then
            zones = {}
            for _, city in ipairs(ctx.data.world.cities) do
                table.insert(zones, city.name or city)
            end
        end

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            activity_type = ctx.random.choice(activity_types),
            risk_score = ctx.random.int(25, 100),
            risk_level = ctx.random.choice(risk_levels),
            auto_flagged = ctx.random.float() < 0.7,
            zone = ctx.random.choice(zones)
        }
    end
}
