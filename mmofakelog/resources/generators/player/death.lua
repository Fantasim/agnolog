-- Player Death Generator

return {
    metadata = {
        name = "player.death",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player death",
        text_template = "[{timestamp}] DEATH: {char_name} killed by {killer} at {zone}",
        tags = {"player", "combat", "death"}
    },

    generate = function(ctx, args)
        local zones = {"Elwynn Forest", "Westfall", "Duskwood", "Stranglethorn Vale", "Burning Steppes"}
        if ctx.data.world and ctx.data.world.leveling_zones and ctx.data.world.leveling_zones.mid_level then
            zones = {}
            for _, zone in ipairs(ctx.data.world.leveling_zones.mid_level) do
                table.insert(zones, zone.name or zone)
            end
        end

        local zone = ctx.random.choice(zones)
        local is_pvp = ctx.random.float(0, 1) < 0.2
        local killer, killer_type

        if is_pvp then
            killer = ctx.gen.character_name()
            killer_type = "player"
        else
            -- Generate monster name
            local monster_types = ctx.data.monsters and ctx.data.monsters.monster_types
            if monster_types and monster_types.prefixes and monster_types.names then
                local mtype = ctx.random.choice(monster_types.types or {"Beast"})
                local prefixes = monster_types.prefixes[mtype] or {"Wild"}
                local names = monster_types.names[mtype] or {"Creature"}
                killer = ctx.random.choice(prefixes) .. " " .. ctx.random.choice(names)
            else
                killer = "Wild Creature"
            end
            killer_type = "mob"
        end

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            killer = killer,
            killer_type = killer_type,
            zone = zone,
            level = ctx.random.int(1, 60),
            durability_loss = ctx.random.int(5, 15)
        }
    end
}
