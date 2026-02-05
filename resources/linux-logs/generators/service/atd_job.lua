-- Atd Job Generator
-- Generates at daemon job execution log entries

return {
    metadata = {
        name = "service.atd_job",
        category = "SERVICE",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "At daemon job execution",
        text_template = "[{timestamp}] atd[{pid}]: Starting job {job_id} for user {user}",
        tags = {"atd", "scheduled"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768),
            job_id = ctx.random.int(1, 99999),
            user = ctx.gen.player_name()
        }
    end
}
