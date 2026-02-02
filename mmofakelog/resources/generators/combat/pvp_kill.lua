-- Combat PvP Kill Generator

return {
    metadata = {
        name = "combat.pvp_kill",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "PvP kill",
        text_template = "[{timestamp}] PVP_KILL: {killer} killed {victim} in {zone}",
        tags = {"combat", "pvp", "kill"}
    },

    generate = function(ctx, args)
        local zones = {"Stranglethorn Vale", "Hillsbrad Foothills", "Ashenvale", "The Barrens"}

        if ctx.data.world and ctx.data.world.leveling_zones then
            zones = {}
            for _, z in ipairs(ctx.data.world.leveling_zones) do
                table.insert(zones, z.name or z)
            end
        end

        return {
            killer = args.killer or ctx.gen.character_name(),
            victim = args.victim or ctx.gen.character_name(),
            killer_level = ctx.random.int(20, 60),
            victim_level = ctx.random.int(20, 60),
            zone = ctx.random.choice(zones),
            honor_gained = ctx.random.int(1, 50)
        }
    end
}
