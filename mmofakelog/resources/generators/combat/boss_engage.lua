-- Combat Boss Engage Generator

return {
    metadata = {
        name = "combat.boss_engage",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Boss engaged",
        text_template = "[{timestamp}] BOSS_ENGAGE: {party_leader}'s group engaged {boss_name}",
        tags = {"combat", "boss", "encounter"}
    },

    generate = function(ctx, args)
        local is_raid = ctx.random.float() < 0.3

        local location
        local raid_size

        if is_raid then
            local raids = {
                {name = "Molten Core", size = 40},
                {name = "Blackwing Lair", size = 40},
                {name = "Naxxramas", size = 40}
            }

            if ctx.data.world and ctx.data.world.raids then
                raids = ctx.data.world.raids
            end

            local raid = ctx.random.choice(raids)
            location = raid.name or raid
            raid_size = ctx.random.choice({10, 25, 40})
        else
            local dungeons = {
                {name = "Deadmines"},
                {name = "Shadowfang Keep"},
                {name = "Stratholme"}
            }

            if ctx.data.world and ctx.data.world.dungeons then
                dungeons = ctx.data.world.dungeons
            end

            local dungeon = ctx.random.choice(dungeons)
            location = dungeon.name or dungeon
            raid_size = 5
        end

        return {
            party_leader = args.party_leader or ctx.gen.character_name(),
            boss_name = ctx.gen.boss_name(),
            boss_health = ctx.random.int(500000, 10000000),
            location = location,
            raid_size = raid_size
        }
    end
}
