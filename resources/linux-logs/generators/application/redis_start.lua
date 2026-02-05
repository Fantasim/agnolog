-- Redis Start Generator
-- Generates Redis start log entries

return {
    metadata = {
        name = "application.redis_start",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Redis started",
        text_template = "[{timestamp}] redis-server[{pid}]: Server started, Redis version {version}",
        tags = {"redis", "cache"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768),
            version = string.format("%d.%d.%d", ctx.random.int(5, 7), ctx.random.int(0, 2), ctx.random.int(0, 10)),
            port = ctx.data.network.protocols.common_ports.redis or 6379
        }
    end
}
