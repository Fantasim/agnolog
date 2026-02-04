-- Server World Event End Generator

return {
    metadata = {
        name = "server.world_event_end",
        category = "SERVER",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "World event ended",
        text_template = "[{timestamp}] WORLD_EVENT_END: \"{event_name}\" ended (participants: {participants})",
        tags = {"server", "event", "world"}
    },

    generate = function(ctx, args)
        local events = {"Darkmoon Faire", "Lunar Festival", "Love is in the Air",
            "Noblegarden", "Children's Week", "Midsummer Fire Festival",
            "Brewfest", "Hallow's End", "Pilgrim's Bounty", "Winter Veil",
            "Elemental Invasion", "Zombie Plague", "World PvP Event"}

        return {
            event_name = ctx.random.choice(events),
            event_id = ctx.random.int(100, 999),
            participants = ctx.random.int(1000, 50000),
            rewards_given = ctx.random.int(500, 25000)
        }
    end
}
