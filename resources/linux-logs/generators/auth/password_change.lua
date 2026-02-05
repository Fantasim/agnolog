-- Password Change Generator
-- Generates password change log entries

return {
    metadata = {
        name = "auth.password_change",
        category = "AUTH",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Password changed",
        text_template = "[{timestamp}] passwd[{pid}]: password changed for {user}",
        tags = {"auth", "password"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(500, 32768),
            user = ctx.gen.username(),
            changed_by = ctx.gen.username()
        }
    end
}
