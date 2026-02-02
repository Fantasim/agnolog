-- Combat Battleground Join Generator

return {
    metadata = {
        name = "combat.battleground_join",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Battleground joined",
        text_template = "[{timestamp}] BG_JOIN: {char_name} joined {bg_name} (queue time: {queue_time}s)",
        tags = {"combat", "battleground", "pvp"}
    },

    generate = function(ctx, args)
        local battlegrounds = {
            "Warsong Gulch", "Arathi Basin", "Alterac Valley",
            "Eye of the Storm", "Strand of the Ancients"
        }

        if ctx.data.world and ctx.data.world.battlegrounds then
            battlegrounds = {}
            for _, bg in ipairs(ctx.data.world.battlegrounds) do
                if bg.type ~= "arena" then
                    table.insert(battlegrounds, bg.name or bg)
                end
            end
        end

        local factions = {"Alliance", "Horde"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            bg_name = ctx.random.choice(battlegrounds),
            queue_time = ctx.random.int(30, 1800),
            team = ctx.random.choice(factions)
        }
    end
}
