return {
    metadata = {
        name = "technical.rate_limit_exceeded",
        category = "TECHNICAL",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "API rate limit exceeded",
        text_template = "[{timestamp}] RATE_LIMIT: {ip_address} exceeded limit on {endpoint}",
        tags = {"technical", "rate_limit", "api"},
        merge_groups = {"api_requests"}
    },
    generate = function(ctx, args)
        local endpoints = {"/api/game/move", "/api/matchmaking/queue", "/api/puzzle/fetch", "/api/user/profile"}

        return {
            ip_address = ctx.gen.ip_address(),
            user_id = ctx.gen.uuid(),
            endpoint = ctx.random.choice(endpoints),
            requests_count = ctx.random.int(300, 1000),
            limit = ctx.random.choice({300, 600, 1000}),
            window_seconds = ctx.random.choice({60, 300, 3600}),
            blocked_duration_seconds = ctx.random.choice({60, 300, 600})
        }
    end
}
