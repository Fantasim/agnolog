-- Security Teleport Hack Generator

return {
    metadata = {
        name = "security.teleport_hack",
        category = "SECURITY",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Unauthorized teleport detected",
        text_template = "[{timestamp}] TELEPORT_HACK: {char_name} unauthorized teleport {from_zone} -> {to_zone}",
        tags = {"security", "cheat", "teleport"},
        merge_groups = {"security_violations"}
    },

    generate = function(ctx, args)
        local zones = {"Stormwind", "Orgrimmar", "Elwynn Forest", "Durotar", "Westfall"}

        if ctx.data.world then
            zones = {}
            if ctx.data.world.cities then
                for _, city in ipairs(ctx.data.world.cities) do
                    table.insert(zones, city.name or city)
                end
            end
            if ctx.data.world.leveling_zones then
                for _, z in ipairs(ctx.data.world.leveling_zones) do
                    table.insert(zones, z.name or z)
                end
            end
        end

        local from_zone = ctx.random.choice(zones)
        local to_zone = ctx.random.choice(zones)

        local actions = {"kick", "temp_ban", "flagged"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            from_zone = from_zone,
            to_zone = to_zone,
            distance = ctx.random.int(1000, 50000),
            action_taken = ctx.random.choice(actions)
        }
    end
}
