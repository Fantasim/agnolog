return {
    metadata = {
        name = "security.multiple_login_detected",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Multiple simultaneous login detected",
        text_template = "[{timestamp}] MULTI_LOGIN: {username} logged in from {location1} and {location2}",
        tags = {"security", "multiple_login"},
        merge_groups = {"security_events"}
    },
    generate = function(ctx, args)
        return {
            username = ctx.gen.player_name(),
            ip_address1 = ctx.gen.ip_address(),
            ip_address2 = ctx.gen.ip_address(),
            location1 = ctx.random.choice({"New York", "London", "Moscow", "Mumbai", "Shanghai"}),
            location2 = ctx.random.choice({"Los Angeles", "Paris", "Berlin", "Tokyo", "Sydney"}),
            time_difference_seconds = ctx.random.int(1, 600),
            action_taken = ctx.random.choice({"session_terminated", "alert_sent", "under_review"})
        }
    end
}
