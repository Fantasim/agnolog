return {
    metadata = {
        name = "game.resign",
        category = "GAME",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player resigns from a game",
        text_template = "[{timestamp}] RESIGN: {player} resigned against {opponent} on move {move_number}",
        tags = {"game", "resign"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            opponent = ctx.gen.player_name(),
            player_elo = ctx.random.int(800, 2800),
            move_number = ctx.random.int(10, 60),
            time_remaining_seconds = ctx.random.int(0, 300),
            material_deficit = ctx.random.int(-5, 15)  -- Negative means player is ahead
        }
    end
}
