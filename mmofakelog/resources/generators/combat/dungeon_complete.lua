-- Combat Dungeon Complete Generator

return {
    metadata = {
        name = "combat.dungeon_complete",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Dungeon completed",
        text_template = "[{timestamp}] DUNGEON_CLEAR: {party_leader}'s party completed {dungeon_name} in {time_taken}",
        tags = {"combat", "dungeon", "completion"}
    },

    generate = function(ctx, args)
        local dungeons = {
            {name = "Deadmines", min_level = 15, max_level = 21},
            {name = "Wailing Caverns", min_level = 15, max_level = 25},
            {name = "Shadowfang Keep", min_level = 22, max_level = 30},
            {name = "Scarlet Monastery", min_level = 30, max_level = 45},
            {name = "Stratholme", min_level = 55, max_level = 60}
        }

        if ctx.data.world and ctx.data.world.dungeons then
            dungeons = ctx.data.world.dungeons
        end

        local dungeon = ctx.random.choice(dungeons)
        local time_seconds = ctx.random.int(900, 5400)  -- 15-90 minutes

        local time_taken = math.floor(time_seconds / 60) .. "m " .. (time_seconds % 60) .. "s"

        local difficulties = {"normal", "heroic"}

        return {
            party_leader = args.party_leader or ctx.gen.character_name(),
            dungeon_name = dungeon.name or dungeon,
            time_taken = time_taken,
            time_seconds = time_seconds,
            bosses_killed = ctx.random.int(3, 7),
            deaths = ctx.random.int(0, 10),
            difficulty = ctx.random.choice(difficulties)
        }
    end
}
