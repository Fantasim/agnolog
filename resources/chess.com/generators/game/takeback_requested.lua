return {
    metadata = {
        name = "game.takeback_requested",
        category = "GAME",
        severity = "DEBUG",
        recurrence = "NORMAL",
        description = "Player requests to take back a move",
        text_template = "[{timestamp}] TAKEBACK: {player} requested takeback - {accepted}",
        tags = {"game", "takeback"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        local accepted = ctx.random.float(0, 1) < 0.2  -- Usually declined

        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            opponent = ctx.gen.player_name(),
            move_number = ctx.random.int(5, 40),
            accepted = accepted,
            casual_game = ctx.random.float(0, 1) < 0.8  -- More common in casual games
        }
    end
}
