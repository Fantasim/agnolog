-- Su Failure Generator
-- Generates failed su attempt log entries

return {
    metadata = {
        name = "auth.su_failure",
        category = "AUTH",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Failed su attempt",
        text_template = "[{timestamp}] su[{pid}]: FAILED su for {target_user} by {source_user}",
        tags = {"auth", "su", "failure"},
        merge_groups = {"auth_failures"}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(500, 32768),
            source_user = ctx.gen.player_name(),
            target_user = "root",
            tty = ctx.random.choice({"pts/0", "pts/1"})
        }
    end
}
