return {
    metadata = {
        name = "matchmaking.pairing_calculated",
        category = "MATCHMAKING",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Matchmaking algorithm calculates pairing",
        text_template = "[{timestamp}] PAIRING: Algorithm matched players with {elo_diff} ELO difference",
        tags = {"matchmaking", "algorithm"},
        merge_groups = {"matchmaking"}
    },
    generate = function(ctx, args)
        return {
            player1 = ctx.gen.player_name(),
            player2 = ctx.gen.player_name(),
            player1_elo = ctx.random.int(800, 2800),
            player2_elo = ctx.random.int(800, 2800),
            elo_diff = ctx.random.int(0, 200),
            quality_score = ctx.random.float(0.5, 1.0),
            calculation_time_ms = ctx.random.int(5, 50),
            pool_size = ctx.random.int(50, 5000)
        }
    end
}
