return {
    metadata = {
        name = "matchmaking.opponent_search",
        category = "MATCHMAKING",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Searching for suitable opponent",
        text_template = "[{timestamp}] SEARCH: Looking for opponent for {username} ({elo})",
        tags = {"matchmaking", "search"},
        merge_groups = {"matchmaking"}
    },
    generate = function(ctx, args)
        return {
            username = ctx.gen.player_name(),
            elo = ctx.random.int(800, 2800),
            elo_range_min = ctx.random.int(700, 2700),
            elo_range_max = ctx.random.int(900, 2900),
            available_opponents = ctx.random.int(10, 500),
            search_iteration = ctx.random.int(1, 10),
            max_wait_time = ctx.random.int(10, 60)
        }
    end
}
