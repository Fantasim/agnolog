-- Su Success Generator
-- Generates successful su command log entries

return {
    metadata = {
        name = "auth.su_success",
        category = "AUTH",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Successful su command",
        text_template = "[{timestamp}] su[{pid}]: Successful su for {target_user} by {source_user}",
        tags = {"auth", "su", "privilege"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local target_users = {"root", ctx.gen.player_name()}

        return {
            pid = ctx.random.int(500, 32768),
            source_user = ctx.gen.player_name(),
            target_user = ctx.random.choice(target_users),
            tty = ctx.random.choice({"pts/0", "pts/1", "tty1"})
        }
    end
}
