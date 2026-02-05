return {
    metadata = {
        name = "server.active_games",
        category = "SERVER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Number of active games on server",
        text_template = "[{timestamp}] ACTIVE_GAMES: {total_games} games ({bullet} bullet, {blitz} blitz, {rapid} rapid)",
        tags = {"server", "metrics", "games"},
        merge_groups = {"server_metrics"}
    },
    generate = function(ctx, args)
        local bullet = ctx.random.int(5000, 15000)
        local blitz = ctx.random.int(8000, 20000)
        local rapid = ctx.random.int(2000, 8000)
        local classical = ctx.random.int(500, 2000)
        local daily = ctx.random.int(10000, 30000)

        return {
            total_games = bullet + blitz + rapid + classical + daily,
            bullet = bullet,
            blitz = blitz,
            rapid = rapid,
            classical = classical,
            daily = daily,
            rated = ctx.random.int(15000, 40000),
            unrated = ctx.random.int(5000, 15000)
        }
    end
}
