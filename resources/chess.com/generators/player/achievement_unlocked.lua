return {
    metadata = {
        name = "player.achievement_unlocked",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player unlocks an achievement",
        text_template = "[{timestamp}] ACHIEVEMENT: {username} unlocked '{achievement_name}'",
        tags = {"player", "achievement"},
        merge_groups = {"player_events"}
    },
    generate = function(ctx, args)
        local achievements = {
            "First Win",
            "100 Games Played",
            "1000 Games Played",
            "Win Streak 5",
            "Win Streak 10",
            "Checkmate Master",
            "Puzzle Expert",
            "Tournament Winner",
            "Rating Milestone 1500",
            "Rating Milestone 2000",
            "Perfect Game",
            "Comeback King",
            "Speed Demon",
            "Tactician",
            "Endgame Expert"
        }

        return {
            username = ctx.gen.player_name(),
            achievement_id = ctx.gen.uuid(),
            achievement_name = ctx.random.choice(achievements),
            points_earned = ctx.random.int(10, 100),
            rarity = ctx.random.choice({"common", "uncommon", "rare", "epic", "legendary"})
        }
    end
}
