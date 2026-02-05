return {
    metadata = {
        name = "matchmaking.tournament_eliminated",
        category = "MATCHMAKING",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player eliminated from tournament",
        text_template = "[{timestamp}] TOURNAMENT_OUT: {username} eliminated - placed {final_position}",
        tags = {"matchmaking", "tournament", "elimination"},
        merge_groups = {"tournaments"}
    },
    generate = function(ctx, args)
        return {
            username = ctx.gen.player_name(),
            tournament_id = ctx.gen.uuid(),
            final_position = ctx.random.int(1, 500),
            total_participants = ctx.random.int(50, 500),
            wins = ctx.random.int(0, 10),
            losses = ctx.random.int(1, 10),
            draws = ctx.random.int(0, 5),
            points_scored = ctx.random.float(0, 10),
            prize_won = ctx.random.choice({0, 0, 0, 5, 10, 25, 50, 100})
        }
    end
}
