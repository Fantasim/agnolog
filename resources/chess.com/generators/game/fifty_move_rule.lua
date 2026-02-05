return {
    metadata = {
        name = "game.fifty_move_rule",
        category = "GAME",
        severity = "INFO",
        recurrence = "RARE",
        description = "Game ends by fifty-move rule",
        text_template = "[{timestamp}] FIFTY_MOVE: {white_player} vs {black_player} - draw claimed",
        tags = {"game", "draw", "fifty_move"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        return {
            game_id = ctx.gen.uuid(),
            white_player = ctx.gen.player_name(),
            black_player = ctx.gen.player_name(),
            white_elo = ctx.random.int(1400, 2800),
            black_elo = ctx.random.int(1400, 2800),
            move_number = ctx.random.int(60, 150),
            moves_without_progress = 50,
            claimed_by = ctx.random.choice({"white", "black"})
        }
    end
}
