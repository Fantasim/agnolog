-- Technical Cache Miss Generator

return {
    metadata = {
        name = "technical.cache_miss",
        category = "TECHNICAL",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Cache miss",
        text_template = "[{timestamp}] CACHE_MISS: {cache_key} ({cache_type}, fetch_time: {fetch_time}ms)",
        tags = {"technical", "cache", "miss"},
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
        local reasons = {"not_found", "expired", "evicted", "first_access"}

        return {
            cache_key = cache_type .. ":" .. ctx.random.int(10000, 99999),
            cache_type = cache_type,
            fetch_time = ctx.random.int(1, 500),
            reason = ctx.random.choice(reasons),
            populated = ctx.random.float() > 0.1
        }
    end
}
