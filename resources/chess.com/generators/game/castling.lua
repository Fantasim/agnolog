return {
    metadata = {
        name = "game.castling",
        category = "GAME",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Player castles their king",
        text_template = "[{timestamp}] CASTLE: {player} castled {castle_type}",
        tags = {"game", "move", "castle"},
        merge_groups = {"game_moves"}
    },
    generate = function(ctx, args)
        local castle_type = ctx.random.choice({"kingside", "queenside"})

        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            castle_type = castle_type,
            move_number = ctx.random.int(5, 15),
            color = ctx.random.choice({"white", "black"})
        }
    end
}
