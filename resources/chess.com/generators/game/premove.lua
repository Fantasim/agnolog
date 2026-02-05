return {
    metadata = {
        name = "game.premove",
        category = "GAME",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Player makes a premove",
        text_template = "[{timestamp}] PREMOVE: {player} premoving {move}",
        tags = {"game", "premove"},
        merge_groups = {"game_moves"}
    },
    generate = function(ctx, args)
        local moves = {"e4", "d4", "Nf3", "c4", "Nc3", "Bxc6", "Qxd4", "Rxe8", "O-O"}

        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            move = ctx.random.choice(moves),
            move_number = ctx.random.int(10, 50),
            time_control_category = ctx.random.choice({"bullet", "blitz"}),  -- More common in fast games
            executed = ctx.random.float(0, 1) < 0.9  -- Usually the premove is valid
        }
    end
}
