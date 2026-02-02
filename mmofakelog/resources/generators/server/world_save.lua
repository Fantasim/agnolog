-- Server World Save Generator

return {
    metadata = {
        name = "server.world_save",
        category = "SERVER",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "World state saved",
        text_template = "[{timestamp}] WORLD_SAVE: Saved {entity_count} entities in {duration}ms",
        tags = {"server", "world", "persistence"}
    },

    generate = function(ctx, args)
        return {
            entity_count = ctx.random.int(100000, 1000000),
            duration = ctx.random.int(1000, 10000),
            player_count = ctx.random.int(100, 5000),
            items_saved = ctx.random.int(1000000, 10000000),
            size_mb = ctx.random.int(100, 2000)
        }
    end
}
