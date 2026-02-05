-- User Modify Generator
-- Generates user account modification log entries

return {
    metadata = {
        name = "auth.user_modify",
        category = "AUTH",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "User account modified",
        text_template = "[{timestamp}] usermod[{pid}]: change user '{user}' {change_description}",
        tags = {"auth", "user", "admin"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local changes = {
            "password changed",
            "UID changed",
            "GID changed",
            "shell changed",
            "home directory changed",
            "added to group sudo",
            "removed from group docker",
            "account locked",
            "account unlocked"
        }

        return {
            pid = ctx.random.int(500, 32768),
            user = ctx.gen.player_name(),
            change_description = ctx.random.choice(changes)
        }
    end
}
