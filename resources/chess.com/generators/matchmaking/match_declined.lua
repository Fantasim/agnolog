return {
    metadata = {
        name = "matchmaking.match_declined",
        category = "MATCHMAKING",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Player declined a match",
        text_template = "[{timestamp}] MATCH_DECLINED: {username} declined match against {opponent}",
        tags = {"matchmaking", "decline"},
        merge_groups = {"matchmaking"}
    },
    generate = function(ctx, args)
        local reasons = {
            "manual_decline",
            "timeout",
            "opponent_rating_mismatch",
            "changed_mind",
            "connection_issue"
        }

        return {
            username = ctx.gen.player_name(),
            opponent = ctx.gen.player_name(),
            match_id = ctx.gen.uuid(),
            decline_reason = ctx.random.choice(reasons),
            response_time_seconds = ctx.random.int(1, 30)
        }
    end
}
