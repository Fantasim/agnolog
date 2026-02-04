-- Server Spawn Wave Generator

return {
    metadata = {
        name = "server.spawn_wave",
        category = "SERVER",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Mob spawn wave",
        text_template = "[{timestamp}] SPAWN: {count} {mob_type} spawned in {zone}",
        tags = {"server", "spawn", "monsters"}
    },

    generate = function(ctx, args)
        local mob_types = {"wolves", "bandits", "undead", "elementals", "demons",
            "beasts", "humanoids", "giants", "dragonkin", "aberrations"}

        -- monster_types.yaml has types as a sub-key
        local types_data = ctx.data.monsters and ctx.data.monsters.monster_types and ctx.data.monsters.monster_types.types
        if types_data then
            mob_types = {}
            for _, mt in ipairs(types_data) do
                table.insert(mob_types, mt.name or mt)
            end
            if #mob_types == 0 then
                mob_types = {"wolves", "bandits", "undead", "elementals", "demons"}
            end
        end

        local zones = {"Elwynn Forest", "Westfall", "Duskwood", "Redridge"}

        if ctx.data.world then
            zones = {}
            if ctx.data.world.starting_zones then
                for _, z in ipairs(ctx.data.world.starting_zones) do
                    table.insert(zones, z.name or z)
                end
            end
            -- leveling_zones has low_level, mid_level, high_level sub-tables
            if ctx.data.world.leveling_zones then
                for _, level_category in pairs(ctx.data.world.leveling_zones) do
                    if type(level_category) == "table" then
                        for _, z in ipairs(level_category) do
                            table.insert(zones, z.name or z)
                        end
                    end
                end
            end
            if #zones == 0 then
                zones = {"Elwynn Forest", "Westfall", "Duskwood", "Redridge"}
            end
        end

        return {
            count = ctx.random.int(5, 50),
            mob_type = ctx.random.choice(mob_types),
            zone = ctx.random.choice(zones),
            spawn_point = "spawn_" .. ctx.random.int(1, 100)
        }
    end
}
