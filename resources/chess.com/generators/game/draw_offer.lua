return {
    metadata = {
        name = "game.draw_offer",
        category = "GAME",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Player offers a draw",
        text_template = "[{timestamp}] DRAW_OFFER: {player} offered draw to {opponent} - {accepted}",
        tags = {"game", "draw", "offer"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        local accepted = ctx.random.float(0, 1) < 0.3

        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            opponent = ctx.gen.player_name(),
            move_number = ctx.random.int(20, 50),
            accepted = accepted,
            response_time_seconds = ctx.random.int(1, 30)
        }
    end
}
