return {
    metadata = {
        name = "game.promotion",
        category = "GAME",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Pawn is promoted to another piece",
        text_template = "[{timestamp}] PROMOTION: {player} promoted pawn to {piece}",
        tags = {"game", "move", "promotion"},
        merge_groups = {"game_moves"}
    },
    generate = function(ctx, args)
        local pieces = {"Queen", "Rook", "Bishop", "Knight"}
        local weights = {90, 5, 3, 2}  -- Queen is most common

        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            piece = ctx.random.weighted_choice(pieces, weights),
            square = ctx.random.choice({"a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8", "a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1"}),
            move_number = ctx.random.int(30, 70),
            underpromotion = ctx.random.float(0, 1) < 0.1  -- Promoting to non-Queen
        }
    end
}
