-- Technical Rate Limit Generator

return {
    metadata = {
        name = "technical.rate_limit",
        category = "TECHNICAL",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Rate limit exceeded",
        text_template = "[{timestamp}] RATE_LIMIT: {client} exceeded {limit_type} ({current}/{max} in {window}s)",
        tags = {"technical", "rate_limit", "throttle"}
    },

    generate = function(ctx, args)
        local limit_types = {
            {name = "requests_per_second", max = 100, window = 1},
            {name = "logins_per_minute", max = 5, window = 60},
            {name = "chat_messages_per_minute", max = 30, window = 60},
            {name = "trade_requests_per_minute", max = 10, window = 60},
            {name = "auction_listings_per_hour", max = 50, window = 3600},
            {name = "api_calls_per_minute", max = 60, window = 60}
        }

        local limit = ctx.random.choice(limit_types)
        local current = limit.max + ctx.random.int(1, 50)
        local actions = {"throttled", "blocked", "warned"}

        return {
            client = ctx.gen.ip_address() .. ":" .. ctx.random.int(1024, 65535),
            session_id = ctx.gen.session_id(),
            limit_type = limit.name,
            current = current,
            max = limit.max,
            window = limit.window,
            action = ctx.random.choice(actions)
        }
    end
}
