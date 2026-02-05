return {
    metadata = {
        name = "game.threefold_repetition",
        category = "GAME",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Game ends by threefold repetition",
        text_template = "[{timestamp}] THREEFOLD: {white_player} vs {black_player} - draw by repetition",
        tags = {"game", "draw", "repetition"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        return {
            game_id = ctx.gen.uuid(),
            white_player = ctx.gen.player_name(),
            black_player = ctx.gen.player_name(),
            white_elo = ctx.random.int(1200, 2800),
            black_elo = ctx.random.int(1200, 2800),
            move_number = ctx.random.int(25, 80),
            claimed_by = ctx.random.choice({"white", "black"}),
            automatic = ctx.random.float(0, 1) < 0.2
        }
    end
}
