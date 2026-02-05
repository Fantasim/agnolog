return {
    metadata = {
        name = "player.lesson_started",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player starts a chess lesson",
        text_template = "[{timestamp}] LESSON_START: {username} started lesson '{lesson_title}'",
        tags = {"player", "lesson", "education"},
        merge_groups = {"player_training"}
    },
    generate = function(ctx, args)
        local lessons = {
            "Basic Opening Principles",
            "Tactical Patterns",
            "Endgame Fundamentals",
            "Attacking the King",
            "Positional Play",
            "Pawn Structure",
            "Bishop vs Knight",
            "Rook Endgames",
            "Queen and Pawn Endings",
            "Checkmate Patterns"
        }

        return {
            username = ctx.gen.player_name(),
            lesson_id = ctx.gen.uuid(),
            lesson_title = ctx.random.choice(lessons),
            lesson_level = ctx.random.choice({"beginner", "intermediate", "advanced"}),
            player_elo = ctx.random.int(800, 2800),
            is_premium = ctx.random.float(0, 1) < 0.3
        }
    end
}
