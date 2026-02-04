-- Server World Event Start Generator

return {
    metadata = {
        name = "server.world_event_start",
        category = "SERVER",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "World event started",
        text_template = "[{timestamp}] WORLD_EVENT_START: \"{event_name}\" started in {zone}",
        tags = {"server", "event", "world"}
    },

    generate = function(ctx, args)
        local events = {"Darkmoon Faire", "Lunar Festival", "Love is in the Air",
            "Noblegarden", "Children's Week", "Midsummer Fire Festival",
            "Brewfest", "Hallow's End", "Pilgrim's Bounty", "Winter Veil",
            "Elemental Invasion", "Zombie Plague", "World PvP Event"}

        local zones = {"Elwynn Forest", "Durotar", "Mulgore", "Stormwind", "Orgrimmar"}

        if ctx.data.world and ctx.data.world.starting_zones then
            zones = {}
            for _, z in ipairs(ctx.data.world.starting_zones) do
                table.insert(zones, z.name or z)
            end
        end

        local durations = {24, 48, 168, 336}

        return {
            event_name = ctx.random.choice(events),
            event_id = ctx.random.int(100, 999),
            zone = ctx.random.choice(zones),
            duration_hours = ctx.random.choice(durations)
        }
    end
}
