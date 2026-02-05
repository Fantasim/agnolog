-- Login Failure Generator
-- Generates failed console/GUI login log entries

return {
    metadata = {
        name = "auth.login_failure",
        category = "AUTH",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Console/GUI login failure",
        text_template = "[{timestamp}] login[{pid}]: FAILED LOGIN ({attempts}) on '{tty}' FOR '{user}', {reason}",
        tags = {"auth", "login", "failure"},
        merge_groups = {"auth_failures"}
    },

    generate = function(ctx, args)
        local reasons = {
            "Authentication failure",
            "Invalid user",
            "Account locked",
            "Password incorrect"
        }

        local ttys = {"tty1", "tty2", "pts/0", "pts/1"}

        return {
            pid = ctx.random.int(500, 5000),
            attempts = ctx.random.int(1, 5),
            tty = ctx.random.choice(ttys),
            user = ctx.gen.username(),
            reason = ctx.random.choice(reasons)
        }
    end
}
