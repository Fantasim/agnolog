return {
    metadata = {
        name = "technical.cache_hit",
        category = "TECHNICAL",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Cache hit for data retrieval",
        text_template = "[{timestamp}] CACHE_HIT: {cache_key} - saved {time_saved_ms}ms",
        tags = {"technical", "cache", "performance"},
        merge_groups = {"cache_ops"}
    },
    generate = function(ctx, args)
        local cache_types = {
            "user_profile",
            "game_state",
            "leaderboard",
            "puzzle_data",
            "opening_book",
            "rating_history"
        }

        return {
            cache_key = ctx.random.choice(cache_types) .. ":" .. ctx.gen.uuid(),
            cache_type = ctx.random.choice(cache_types),
            time_saved_ms = ctx.random.int(10, 200),
            ttl_remaining_seconds = ctx.random.int(60, 3600),
            data_size_bytes = ctx.random.int(100, 50000)
        }
    end
}
