return {
    metadata = {
        name = "server.concurrent_users",
        category = "SERVER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Concurrent users online",
        text_template = "[{timestamp}] CONCURRENT_USERS: {total_users} online ({playing} playing, {spectating} spectating)",
        tags = {"server", "metrics", "users"},
        merge_groups = {"server_metrics"}
    },
    generate = function(ctx, args)
        local playing = ctx.random.int(50000, 150000)
        local spectating = ctx.random.int(10000, 40000)
        local in_queue = ctx.random.int(5000, 20000)
        local idle = ctx.random.int(20000, 80000)

        return {
            total_users = playing + spectating + in_queue + idle,
            playing = playing,
            spectating = spectating,
            in_queue = in_queue,
            idle = idle,
            peak_today = ctx.random.int(200000, 500000)
        }
    end
}
