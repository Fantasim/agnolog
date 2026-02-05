return {
    metadata = {
        name = "matchmaking.tournament_started",
        category = "MATCHMAKING",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Tournament begins",
        text_template = "[{timestamp}] TOURNAMENT_START: '{tournament_name}' started with {participants} players",
        tags = {"matchmaking", "tournament", "start"},
        merge_groups = {"tournaments"}
    },
    generate = function(ctx, args)
        local tournaments = {
            "Daily Blitz Arena",
            "Weekend Swiss Tournament",
            "Titled Tuesday",
            "Bullet Brawl",
            "Rapid Championship"
        }

        return {
            tournament_id = ctx.gen.uuid(),
            tournament_name = ctx.random.choice(tournaments),
            participants = ctx.random.int(20, 500),
            time_control = ctx.random.choice({"Bullet 1+0", "Blitz 3+2", "Rapid 10+0"}),
            rounds = ctx.random.int(5, 11),
            prize_pool = ctx.random.choice({0, 100, 500, 1000, 5000})
        }
    end
}
