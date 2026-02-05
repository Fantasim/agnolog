return {
    metadata = {
        name = "game.move_made",
        category = "GAME",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Player makes a move in a game",
        text_template = "[{timestamp}] MOVE: {player} ({elo}) played {move} in {game_id} - move {move_number}",
        tags = {"game", "move"},
        merge_groups = {"game_moves"}
    },
    generate = function(ctx, args)
        local openings = ctx.data.game.openings

        -- Common chess moves in algebraic notation
        local moves = {
            "e4", "d4", "Nf3", "c4", "e5", "c5", "Nc6", "d5", "Nf6",
            "Bc4", "Bb5", "Nc3", "g3", "f4", "d6", "c6", "e6", "g6",
            "Be2", "Bg2", "O-O", "Qe2", "Re1", "Bd3", "h3", "a3",
            "Qxd4", "Nxe5", "Bxc6", "Rxf8", "Kxf8",
            "a4", "b4", "h4", "a5", "b5", "h5"
        }

        local move_number = ctx.random.int(1, 50)
        local time_remaining = ctx.random.int(5, 300)

        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            elo = ctx.random.int(800, 2800),
            move = ctx.random.choice(moves),
            move_number = move_number,
            time_remaining_seconds = time_remaining,
            time_taken_seconds = ctx.random.float(0.5, 30),
            is_book_move = ctx.random.float(0, 1) < 0.2 and move_number <= 10,
            opening = ctx.random.choice(openings).name
        }
    end
}
