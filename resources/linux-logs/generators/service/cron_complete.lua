-- Cron Complete Generator
-- Generates cron job completion log entries

return {
    metadata = {
        name = "service.cron_complete",
        category = "SERVICE",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Cron job completed",
        text_template = "[{timestamp}] CRON[{pid}]: ({user}) session closed for user {user}",
        tags = {"cron", "scheduled"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768),
            user = ctx.random.choice({"root", ctx.gen.player_name()}),
            duration_seconds = ctx.random.int(1, 3600)
        }
    end
}
