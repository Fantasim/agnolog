return {
    metadata = {
        name = "security.fair_play_violation",
        category = "SECURITY",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Fair play violation confirmed",
        text_template = "[{timestamp}] FAIR_PLAY: {username} violated fair play - {violation_type}",
        tags = {"security", "cheat_detection", "fair_play"},
        merge_groups = {"security_violations"}
    },
    generate = function(ctx, args)
        local violation_types = {
            "engine_assistance",
            "multiple_tabs",
            "suspicious_accuracy",
            "time_pattern_anomaly",
            "sandbagging",
            "collusion",
            "rating_manipulation"
        }

        return {
            username = ctx.gen.player_name(),
            game_id = ctx.gen.uuid(),
            violation_type = ctx.random.choice(violation_types),
            confidence_score = ctx.random.float(0.85, 1.0),
            elo_rating = ctx.random.int(1200, 2500),
            games_flagged = ctx.random.int(1, 10),
            evidence_strength = ctx.random.choice({"moderate", "strong", "conclusive"}),
            action_taken = ctx.random.choice({"warning", "temporary_ban", "permanent_ban", "under_review"})
        }
    end
}
