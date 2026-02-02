-- Technical Queue Depth Generator

return {
    metadata = {
        name = "technical.queue_depth",
        category = "TECHNICAL",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Queue metrics",
        text_template = "[{timestamp}] QUEUE: {queue_name} depth={depth}, processed={processed}/s, avg_wait={avg_wait}ms",
        tags = {"technical", "queue", "metrics"}
    },

    generate = function(ctx, args)
        local queues = {
            "login_queue", "world_update", "combat_events", "chat_messages",
            "mail_delivery", "auction_updates", "guild_updates", "save_queue"
        }

        local queue_name = ctx.random.choice(queues)
        local depth = ctx.random.int(0, 10000)

        -- High depth = lower processing rate
        local processed = math.max(1, math.floor(1000 / math.max(1, depth / 100)))

        local avg_wait = 0
        if depth > 0 then
            avg_wait = ctx.random.int(1, 1000)
        end

        return {
            queue_name = queue_name,
            depth = depth,
            processed = processed,
            avg_wait = avg_wait,
            max_depth = 10000,
            workers = ctx.random.int(1, 16)
        }
    end
}
