-- Combat Raid Enter Generator

return {
    metadata = {
        name = "combat.raid_enter",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Raid entered",
        text_template = "[{timestamp}] RAID_ENTER: {raid_leader}'s raid entered {raid_name} ({raid_size} players)",
        tags = {"combat", "raid", "party"},
        merge_groups = {"instance_runs"}
    },

    generate = function(ctx, args)
        local raids = {
            {name = "Molten Core", size = 40},
            {name = "Blackwing Lair", size = 40},
            {name = "Naxxramas", size = 40},
            {name = "Onyxia's Lair", size = 40},
            {name = "Zul'Gurub", size = 20}
        }

        if ctx.data.world and ctx.data.world.raids then
            raids = ctx.data.world.raids
        end

        local raid = ctx.random.choice(raids)
        local raid_size = raid.size or 40

        local guild = nil
        if ctx.random.float() > 0.3 then
            guild = ctx.gen.guild_name()
        end

        return {
            raid_leader = args.raid_leader or ctx.gen.character_name(),
            raid_name = raid.name or raid,
            raid_size = raid_size,
            guild = guild
        }
    end
}
