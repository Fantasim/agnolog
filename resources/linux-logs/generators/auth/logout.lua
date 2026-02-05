-- Logout Generator
-- Generates user logout log entries

return {
    metadata = {
        name = "auth.logout",
        category = "AUTH",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "User logout",
        text_template = "[{timestamp}] systemd-logind[{pid}]: Session {session_id} logged out. Waiting for processes to exit",
        tags = {"auth", "logout", "session"},
        merge_groups = {"sessions"}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(500, 5000),
            session_id = ctx.random.int(1, 9999),
            user = ctx.gen.player_name(),
            duration = ctx.random.int(60, 28800)
        }
    end
}
