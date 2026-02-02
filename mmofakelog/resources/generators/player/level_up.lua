-- Player Level Up Generator

return {
    metadata = {
        name = "player.level_up",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Player level up",
        text_template = "[{timestamp}] LEVEL_UP: {char_name} reached level {new_level}",
        tags = {"player", "progression"}
    },

    generate = function(ctx, args)
        local max_level = 60
        local new_level = args.level or ctx.random.int(2, max_level)

        -- Get zones from data
        local zones = {"Elwynn Forest", "Westfall", "Duskwood", "Stranglethorn Vale", "Burning Steppes"}
        if ctx.data.world and ctx.data.world.leveling_zones then
            local mid = ctx.data.world.leveling_zones.mid_level
            if mid then
                zones = {}
                for _, zone in ipairs(mid) do
                    table.insert(zones, zone.name or zone)
                end
            end
        end

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            old_level = new_level - 1,
            new_level = new_level,
            zone = ctx.random.choice(zones),
            time_at_level = ctx.random.int(30, 600)
        }
    end
}
