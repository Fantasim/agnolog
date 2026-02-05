return {
    metadata = {
        name = "game.abandonment",
        category = "GAME",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Player abandoned the game",
        text_template = "[{timestamp}] ABANDONED: {player} abandoned game against {opponent}",
        tags = {"game", "abandoned"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            opponent = ctx.gen.player_name(),
            player_elo = ctx.random.int(800, 2000),
            move_number = ctx.random.int(1, 30),
            time_disconnected_seconds = ctx.random.int(60, 300),
            rated_game = ctx.random.float(0, 1) < 0.7
        }
    end
}
