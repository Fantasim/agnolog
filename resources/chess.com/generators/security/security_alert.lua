return {
    metadata = {
        name = "security.alert",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Security alert triggered",
        text_template = "[{timestamp}] SECURITY_ALERT: {alert_type} for {username} - {severity}",
        tags = {"security", "alert"},
        merge_groups = {"security_events"}
    },
    generate = function(ctx, args)
        local alert_types = {
            "unusual_login_location",
            "rapid_rating_change",
            "account_takeover_attempt",
            "payment_fraud_suspected",
            "api_abuse_detected",
            "unusual_activity_pattern"
        }

        return {
            alert_id = ctx.gen.uuid(),
            username = ctx.gen.player_name(),
            alert_type = ctx.random.choice(alert_types),
            severity = ctx.random.choice({"low", "medium", "high", "critical"}),
            confidence = ctx.random.float(0.5, 1.0),
            action_required = ctx.random.float(0, 1) < 0.7,
            automated_response = ctx.random.choice({"none", "email_notification", "account_lock", "session_terminate"})
        }
    end
}
