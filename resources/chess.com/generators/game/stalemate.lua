return {
    metadata = {
        name = "game.stalemate",
        category = "GAME",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Game ends in stalemate",
        text_template = "[{timestamp}] STALEMATE: {white_player} vs {black_player} ended in stalemate",
        tags = {"game", "stalemate", "draw"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        return {
            game_id = ctx.gen.uuid(),
            white_player = ctx.gen.player_name(),
            black_player = ctx.gen.player_name(),
            white_elo = ctx.random.int(800, 2800),
            black_elo = ctx.random.int(800, 2800),
            move_number = ctx.random.int(30, 100),
            stalemating_player = ctx.random.choice({"white", "black"}),
            pieces_remaining = ctx.random.int(2, 8)
        }
    end
}
