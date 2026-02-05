return {
    metadata = {
        name = "game.blunder",
        category = "GAME",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player makes a blunder (bad move)",
        text_template = "[{timestamp}] BLUNDER: {player} blundered - evaluation swing {eval_swing}",
        tags = {"game", "blunder", "mistake"},
        merge_groups = {"game_analysis"}
    },
    generate = function(ctx, args)
        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            player_elo = ctx.random.int(800, 2000),
            move_number = ctx.random.int(10, 50),
            eval_before = ctx.random.float(-2, 2),
            eval_after = ctx.random.float(-8, -3),
            eval_swing = ctx.random.float(3, 10),
            best_move = ctx.random.choice({"Nf6", "Qd5", "Bxf7", "Rxe8"}),
            time_taken_seconds = ctx.random.float(1, 30)
        }
    end
}
