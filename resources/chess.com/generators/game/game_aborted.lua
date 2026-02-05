return {
    metadata = {
        name = "game.aborted",
        category = "GAME",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Game aborted before completion",
        text_template = "[{timestamp}] ABORTED: Game {game_id} aborted - {reason}",
        tags = {"game", "aborted"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        local reasons = {
            "no_moves_made",
            "one_move_only",
            "player_disconnected",
            "mutual_agreement",
            "opponent_left"
        }

        return {
            game_id = ctx.gen.uuid(),
            white_player = ctx.gen.player_name(),
            black_player = ctx.gen.player_name(),
            reason = ctx.random.choice(reasons),
            moves_made = ctx.random.int(0, 2),
            duration_seconds = ctx.random.int(5, 120),
            rated = false
        }
    end
}
