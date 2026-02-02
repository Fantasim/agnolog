-- Combat PvP Death Generator

return {
    metadata = {
        name = "combat.pvp_death",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "PvP death",
        text_template = "[{timestamp}] PVP_DEATH: {victim} killed by {killer}",
        tags = {"combat", "pvp", "death"}
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
            victim = args.victim or ctx.gen.character_name(),
            killer = args.killer or ctx.gen.character_name(),
            zone = ctx.random.choice(zones),
            death_count_session = ctx.random.int(1, 20)
        }
    end
}
