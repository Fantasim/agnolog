-- Server Player Count Generator

return {
    metadata = {
        name = "server.player_count",
        category = "SERVER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Online player count",
        text_template = "[{timestamp}] PLAYERS: {count} online (peak: {peak}, capacity: {capacity})",
        tags = {"server", "players", "stats"},
        merge_groups = {"server_metrics"}
    },

    generate = function(ctx, args)
        local capacity = 5000
        local count = ctx.random.int(100, capacity)
        local peak = math.max(count, ctx.random.int(count, capacity))

        local queue = math.max(0, count - capacity + ctx.random.int(-100, 500))

        return {
            count = count,
            peak = peak,
            capacity = capacity,
            queue = queue,
            unique_today = ctx.random.int(count, count * 3)
        }
    end
}
