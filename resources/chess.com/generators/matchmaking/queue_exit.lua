return {
    metadata = {
        name = "matchmaking.queue_exit",
        category = "MATCHMAKING",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Player exits matchmaking queue",
        text_template = "[{timestamp}] QUEUE_EXIT: {username} left queue after {wait_time}s - {reason}",
        tags = {"matchmaking", "queue"},
        merge_groups = {"matchmaking"}
    },
    generate = function(ctx, args)
        local reasons = {
            "manual_cancel",
            "match_found",
            "timeout",
            "queue_error",
            "connection_lost"
        }

        return {
            username = ctx.gen.player_name(),
            queue_id = ctx.gen.uuid(),
            wait_time_seconds = ctx.random.int(1, 120),
            reason = ctx.random.choice(reasons),
            match_found = ctx.random.float(0, 1) < 0.7
        }
    end
}
