return {
    metadata = {
        name = "game.rematch_offered",
        category = "GAME",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player offers rematch after game",
        text_template = "[{timestamp}] REMATCH: {player} offered rematch to {opponent} - {accepted}",
        tags = {"game", "rematch"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        local accepted = ctx.random.float(0, 1) < 0.4

        return {
            previous_game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            opponent = ctx.gen.player_name(),
            accepted = accepted,
            previous_result = ctx.random.choice({"win", "loss", "draw"}),
            response_time_seconds = ctx.random.int(1, 60)
        }
    end
}
