-- Anacron Start Generator
-- Generates anacron job start log entries

return {
    metadata = {
        name = "service.anacron_start",
        category = "SERVICE",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Anacron job started",
        text_template = "[{timestamp}] anacron[{pid}]: Job `{job}' started",
        tags = {"anacron", "scheduled"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local jobs = {"cron.daily", "cron.weekly", "cron.monthly"}

        return {
            pid = ctx.random.int(1000, 32768),
            job = ctx.random.choice(jobs)
        }
    end
}
