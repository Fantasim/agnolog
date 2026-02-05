return {
    metadata = {
        name = "player.lesson_completed",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player completes a chess lesson",
        text_template = "[{timestamp}] LESSON_COMPLETE: {username} completed lesson - score {score}%",
        tags = {"player", "lesson", "education"},
        merge_groups = {"player_training"}
    },
    generate = function(ctx, args)
        return {
            username = ctx.gen.player_name(),
            lesson_id = ctx.gen.uuid(),
            duration_seconds = ctx.random.int(300, 3600),
            score = ctx.random.int(60, 100),
            exercises_completed = ctx.random.int(5, 20),
            exercises_total = ctx.random.int(10, 25),
            certificate_earned = ctx.random.float(0, 1) < 0.2
        }
    end
}
