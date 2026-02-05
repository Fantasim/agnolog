return {
    metadata = {
        name = "technical.cache_miss",
        category = "TECHNICAL",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Cache miss, fetching from database",
        text_template = "[{timestamp}] CACHE_MISS: {cache_key} - fetching from DB",
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
            db_fetch_time_ms = ctx.random.int(20, 500),
            cache_populated = ctx.random.float(0, 1) < 0.9,
            reason = ctx.random.choice({"expired", "not_found", "invalidated"})
        }
    end
}
