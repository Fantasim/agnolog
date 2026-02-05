return {
    metadata = {
        name = "matchmaking.elo_updated",
        category = "MATCHMAKING",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Player's ELO rating updated after game",
        text_template = "[{timestamp}] ELO_UPDATE: {username} {old_elo} -> {new_elo} ({change})",
        tags = {"matchmaking", "elo", "rating"},
        merge_groups = {"elo_changes"}
    },
    generate = function(ctx, args)
        local old_elo = ctx.random.int(800, 2800)
        local change = ctx.random.int(-40, 40)
        local new_elo = old_elo + change

        return {
            username = ctx.gen.player_name(),
            game_id = ctx.gen.uuid(),
            old_elo = old_elo,
            new_elo = new_elo,
            change = change,
            k_factor = ctx.random.choice({16, 24, 32, 40}),
            opponent_elo = ctx.random.int(old_elo - 200, old_elo + 200),
            result = ctx.random.choice({"win", "loss", "draw"}),
            time_category = ctx.random.choice({"bullet", "blitz", "rapid", "classical"})
        }
    end
}
