-- Combat Mob Aggro Generator

return {
    metadata = {
        name = "combat.mob_aggro",
        category = "COMBAT",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Mob aggro",
        text_template = "[{timestamp}] AGGRO: {mob_name} aggroed on {char_name} in {zone}",
        tags = {"combat", "aggro", "monster"}
    },

    generate = function(ctx, args)
        local zones = {"Elwynn Forest", "Westfall", "Duskwood"}
        if ctx.data.world and ctx.data.world.leveling_zones then
            zones = {}
            -- leveling_zones has low_level, mid_level, high_level sub-tables
            for _, level_category in pairs(ctx.data.world.leveling_zones) do
                if type(level_category) == "table" then
                    for _, z in ipairs(level_category) do
                        table.insert(zones, z.name or z)
                    end
                end
            end
            -- Fallback if no zones found
            if #zones == 0 then
                zones = {"Elwynn Forest", "Westfall", "Duskwood"}
            end
        end

        local zone = ctx.random.choice(zones)

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            mob_id = ctx.random.int(10000, 99999),
            mob_name = ctx.gen.monster_name(),
            mob_level = ctx.random.int(1, 60),
            zone = zone,
            aggro_range = ctx.random.int(10, 40)
        }
    end
}
