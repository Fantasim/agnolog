-- Redis Save Generator
-- Generates Redis background save log entries

return {
    metadata = {
        name = "application.redis_save",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Redis save",
        text_template = "[{timestamp}] redis-server[{pid}]: Background saving started by pid {bg_pid}",
        tags = {"redis", "cache", "persistence"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768),
            bg_pid = ctx.random.int(1000, 32768),
            keys = ctx.random.int(1000, 1000000)
        }
    end
}
