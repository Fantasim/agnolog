return {
    metadata = {
        name = "matchmaking.tournament_registered",
        category = "MATCHMAKING",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player registers for tournament",
        text_template = "[{timestamp}] TOURNAMENT_REG: {username} registered for '{tournament_name}'",
        tags = {"matchmaking", "tournament", "registration"},
        merge_groups = {"tournaments"}
    },
    generate = function(ctx, args)
        local tournaments = {
            "Daily Blitz Arena",
            "Weekend Swiss Tournament",
            "Titled Tuesday",
            "Bullet Brawl",
            "Rapid Championship",
            "Monthly Grand Prix",
            "Beginner's Cup",
            "Master's Invitational"
        }

        return {
            username = ctx.gen.player_name(),
            tournament_id = ctx.gen.uuid(),
            tournament_name = ctx.random.choice(tournaments),
            player_elo = ctx.random.int(800, 2800),
            entry_fee = ctx.random.choice({0, 5, 10, 25, 50}),
            current_participants = ctx.random.int(10, 500),
            max_participants = ctx.random.choice({50, 100, 200, 500, 1000})
        }
    end
}
