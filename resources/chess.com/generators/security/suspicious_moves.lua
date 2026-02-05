return {
    metadata = {
        name = "security.suspicious_moves",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Suspicious move pattern detected",
        text_template = "[{timestamp}] SUSPICIOUS: {username} - {alert_type} detected",
        tags = {"security", "cheat_detection", "suspicious"},
        merge_groups = {"security_violations"}
    },
    generate = function(ctx, args)
        local alert_types = {
            "consistent_engine_moves",
            "impossible_calculation_speed",
            "perfect_accuracy",
            "timing_pattern_anomaly",
            "move_correlation_high"
        }

        return {
            username = ctx.gen.player_name(),
            game_id = ctx.gen.uuid(),
            alert_type = ctx.random.choice(alert_types),
            confidence_score = ctx.random.float(0.6, 0.95),
            player_elo = ctx.random.int(1200, 2500),
            accuracy = ctx.random.int(92, 100),
            avg_move_time = ctx.random.float(3, 10),
            engine_correlation = ctx.random.float(0.75, 0.98)
        }
    end
}
