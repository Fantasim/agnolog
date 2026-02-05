return {
    metadata = {
        name = "game.checkmate",
        category = "GAME",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player delivers checkmate",
        text_template = "[{timestamp}] CHECKMATE: {winner} checkmated {loser} with {mating_piece}",
        tags = {"game", "checkmate", "win"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        local mating_pieces = {"Queen", "Rook", "Bishop", "Knight", "Pawn"}

        return {
            game_id = ctx.gen.uuid(),
            winner = ctx.gen.player_name(),
            loser = ctx.gen.player_name(),
            winner_elo = ctx.random.int(800, 2800),
            loser_elo = ctx.random.int(800, 2800),
            move_number = ctx.random.int(15, 80),
            mating_piece = ctx.random.choice(mating_pieces),
            back_rank_mate = ctx.random.float(0, 1) < 0.15,
            smothered_mate = ctx.random.float(0, 1) < 0.05
        }
    end
}
