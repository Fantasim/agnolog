return {
    metadata = {
        name = "game.check",
        category = "GAME",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Player gives check",
        text_template = "[{timestamp}] CHECK: {player} gave check with {piece}",
        tags = {"game", "check"},
        merge_groups = {"game_moves"}
    },
    generate = function(ctx, args)
        local pieces = {"Queen", "Rook", "Bishop", "Knight", "Pawn"}

        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            piece = ctx.random.choice(pieces),
            move_number = ctx.random.int(10, 60),
            discovered_check = ctx.random.float(0, 1) < 0.15,
            double_check = ctx.random.float(0, 1) < 0.05
        }
    end
}
