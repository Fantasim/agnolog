-- User Add Generator
-- Generates user account creation log entries

return {
    metadata = {
        name = "auth.user_add",
        category = "AUTH",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "User account created",
        text_template = "[{timestamp}] useradd[{pid}]: new user: name={user}, UID={uid}, GID={gid}, home={home}, shell={shell}",
        tags = {"auth", "user", "admin"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local shells = {"/bin/bash", "/bin/sh", "/bin/zsh", "/usr/bin/fish", "/bin/false", "/usr/sbin/nologin"}
        local user = ctx.gen.player_name()

        return {
            pid = ctx.random.int(500, 32768),
            user = user,
            uid = ctx.random.int(1000, 60000),
            gid = ctx.random.int(1000, 60000),
            home = "/home/" .. user,
            shell = ctx.random.choice(shells)
        }
    end
}
