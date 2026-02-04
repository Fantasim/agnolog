-- Combat Dungeon Enter Generator

return {
    metadata = {
        name = "combat.dungeon_enter",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Dungeon entered",
        text_template = "[{timestamp}] DUNGEON_ENTER: {party_leader}'s party entered {dungeon_name} ({party_size} players)",
        tags = {"combat", "dungeon", "party"},
        merge_groups = {"instance_runs"}
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
        local party_size = ctx.random.int(3, 5)

        local party_members = {}
        for i = 1, party_size do
            table.insert(party_members, ctx.gen.character_name())
        end

        local difficulties = {"normal", "heroic"}

        return {
            party_leader = party_members[1],
            party_members = party_members,
            party_size = party_size,
            dungeon_name = dungeon.name or dungeon,
            dungeon_level_min = dungeon.min_level or 15,
            dungeon_level_max = dungeon.max_level or 60,
            difficulty = ctx.random.choice(difficulties)
        }
    end
}
