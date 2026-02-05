return {
    metadata = {
        name = "player.puzzle_completed",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Player completes a puzzle",
        text_template = "[{timestamp}] PUZZLE: {username} completed puzzle {puzzle_id} - {solved}",
        tags = {"player", "puzzle", "training"},
        merge_groups = {"player_training"}
    },
    generate = function(ctx, args)
        local solved = ctx.random.float(0, 1) < 0.7

        return {
            username = ctx.gen.player_name(),
            puzzle_id = ctx.gen.uuid(),
            puzzle_rating = ctx.random.int(800, 2800),
            player_puzzle_rating = ctx.random.int(800, 2800),
            solved = solved,
            attempts = ctx.random.int(1, 5),
            time_taken_seconds = ctx.random.int(10, 300),
            rating_change = solved and ctx.random.int(1, 15) or ctx.random.int(-15, -1),
            theme = ctx.random.choice({"fork", "pin", "skewer", "mate_in_2", "mate_in_3", "endgame", "opening"})
        }
    end
}
