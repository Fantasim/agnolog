-- Combat Dungeon Wipe Generator

return {
    metadata = {
        name = "combat.dungeon_wipe",
        category = "COMBAT",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Party wipe",
        text_template = "[{timestamp}] WIPE: Party wiped in {dungeon_name} at {boss_name}",
        tags = {"combat", "dungeon", "wipe"}
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

        return {
            party_leader = args.party_leader or ctx.gen.character_name(),
            dungeon_name = dungeon.name or dungeon,
            boss_name = ctx.gen.boss_name(),
            attempt_number = ctx.random.int(1, 10),
            best_attempt_percent = ctx.random.int(5, 95)
        }
    end
}
