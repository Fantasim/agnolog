-- Technical Cache Hit Generator

return {
    metadata = {
        name = "technical.cache_hit",
        category = "TECHNICAL",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Cache hit",
        text_template = "[{timestamp}] CACHE_HIT: {cache_key} ({cache_type}, age: {age}ms)",
        tags = {"technical", "cache", "hit"},
        merge_groups = {"cache_ops"}
    },

    generate = function(ctx, args)
        local cache_types = {
            "player", "item", "guild", "quest", "zone",
            "session", "config", "leaderboard"
        }

        if ctx.data.constants and ctx.data.constants.network then
            local nc = ctx.data.constants.network
            if nc.cache_types then cache_types = nc.cache_types end
        end

        local cache_type = ctx.random.choice(cache_types)

        return {
            cache_key = cache_type .. ":" .. ctx.random.int(10000, 99999),
            cache_type = cache_type,
            age = ctx.random.int(1, 3600000),
            size_bytes = ctx.random.int(100, 100000),
            ttl_remaining = ctx.random.int(0, 3600)
        }
    end
}
