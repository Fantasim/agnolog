-- Combat Raid Complete Generator

return {
    metadata = {
        name = "combat.raid_complete",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "RARE",
        description = "Raid cleared",
        text_template = "[{timestamp}] RAID_CLEAR: {raid_leader}'s raid cleared {raid_name} ({bosses_killed} bosses)",
        tags = {"combat", "raid", "completion"}
    },

    generate = function(ctx, args)
        local raids = {
            {name = "Molten Core", size = 40},
            {name = "Blackwing Lair", size = 40},
            {name = "Naxxramas", size = 40}
        }

        if ctx.data.world and ctx.data.world.raids then
            raids = ctx.data.world.raids
        end

        local raid = ctx.random.choice(raids)

        local guild = nil
        if ctx.random.float() > 0.3 then
            guild = ctx.gen.guild_name()
        end

        return {
            raid_leader = args.raid_leader or ctx.gen.character_name(),
            raid_name = raid.name or raid,
            bosses_killed = ctx.random.int(5, 12),
            time_hours = math.floor(ctx.random.float() * 40 + 20) / 10,  -- 2.0 to 6.0
            guild = guild,
            first_clear = ctx.random.float() < 0.02
        }
    end
}
