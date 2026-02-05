-- Login Success Generator
-- Generates successful console/GUI login log entries

return {
    metadata = {
        name = "auth.login_success",
        category = "AUTH",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Console/GUI login success",
        text_template = "[{timestamp}] systemd-logind[{pid}]: New session {session_id} of user {user}",
        tags = {"auth", "login", "session"},
        merge_groups = {"sessions"}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(500, 5000),
            session_id = ctx.random.int(1, 9999),
            user = ctx.gen.username(),
            seat = "seat0",
            vt = ctx.random.int(1, 7)
        }
    end
}
