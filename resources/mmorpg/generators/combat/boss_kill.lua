-- Combat Boss Kill Generator

return {
    metadata = {
        name = "combat.boss_kill",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Boss killed",
        text_template = "[{timestamp}] BOSS_KILL: {party_leader}'s group defeated {boss_name} ({time_taken})",
        tags = {"combat", "boss", "kill"},
        merge_groups = {"boss_fights"}
    },

    generate = function(ctx, args)
        local is_raid = ctx.random.float() < 0.3

        local location

        if is_raid then
            local raids = {
                {name = "Molten Core"},
                {name = "Blackwing Lair"},
                {name = "Naxxramas"}
            }

            if ctx.data.world and ctx.data.world.raids then
                raids = ctx.data.world.raids
            end

            local raid = ctx.random.choice(raids)
            location = raid.name or raid
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
        end

        local time_seconds = ctx.random.int(60, 600)
        local time_taken = math.floor(time_seconds / 60) .. "m " .. (time_seconds % 60) .. "s"

        return {
            party_leader = args.party_leader or ctx.gen.character_name(),
            boss_name = ctx.gen.boss_name(),
            location = location,
            time_taken = time_taken,
            time_seconds = time_seconds,
            deaths = ctx.random.int(0, 20),
            first_kill = ctx.random.float() < 0.05
        }
    end
}
