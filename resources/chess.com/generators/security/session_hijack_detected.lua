return {
    metadata = {
        name = "security.session_hijack_detected",
        category = "SECURITY",
        severity = "CRITICAL",
        recurrence = "RARE",
        description = "Possible session hijacking detected",
        text_template = "[{timestamp}] HIJACK_DETECTED: Session {session_id} for {username} - suspicious activity",
        tags = {"security", "session", "hijack"},
        merge_groups = {"security_violations"}
    },
    generate = function(ctx, args)
        return {
            session_id = ctx.gen.session_id(),
            username = ctx.gen.player_name(),
            original_ip = ctx.gen.ip_address(),
            suspicious_ip = ctx.gen.ip_address(),
            location_change_km = ctx.random.int(500, 15000),
            time_between_requests_seconds = ctx.random.int(1, 60),
            session_terminated = true,
            user_notified = true
        }
    end
}
