return {
    metadata = {
        name = "game.timeout",
        category = "GAME",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player runs out of time",
        text_template = "[{timestamp}] TIMEOUT: {player} ran out of time against {opponent}",
        tags = {"game", "timeout"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            opponent = ctx.gen.player_name(),
            player_elo = ctx.random.int(800, 2800),
            move_number = ctx.random.int(5, 70),
            opponent_time_remaining = ctx.random.int(1, 300),
            time_control_category = ctx.random.choice({"bullet", "blitz", "rapid"})
        }
    end
}
