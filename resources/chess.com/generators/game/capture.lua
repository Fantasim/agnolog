return {
    metadata = {
        name = "game.capture",
        category = "GAME",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Player captures a piece",
        text_template = "[{timestamp}] CAPTURE: {player} captured {captured_piece} with {capturing_piece}",
        tags = {"game", "capture"},
        merge_groups = {"game_moves"}
    },
    generate = function(ctx, args)
        local pieces = {"Pawn", "Knight", "Bishop", "Rook", "Queen"}
        local values = {1, 3, 3, 5, 9}

        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            capturing_piece = ctx.random.choice(pieces),
            captured_piece = ctx.random.choice(pieces),
            move_number = ctx.random.int(5, 60),
            is_exchange = ctx.random.float(0, 1) < 0.3,  -- Trading pieces
            material_gain = ctx.random.int(-4, 8)
        }
    end
}
