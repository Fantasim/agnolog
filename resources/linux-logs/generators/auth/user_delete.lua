-- User Delete Generator
-- Generates user account deletion log entries

return {
    metadata = {
        name = "auth.user_delete",
        category = "AUTH",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "User account deleted",
        text_template = "[{timestamp}] userdel[{pid}]: delete user '{user}'",
        tags = {"auth", "user", "admin"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(500, 32768),
            user = ctx.gen.player_name(),
            removed_home = ctx.random.choice({true, false})
        }
    end
}
