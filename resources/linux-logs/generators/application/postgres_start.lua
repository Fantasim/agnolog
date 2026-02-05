-- PostgreSQL Start Generator
-- Generates PostgreSQL start log entries

return {
    metadata = {
        name = "application.postgres_start",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "PostgreSQL started",
        text_template = "[{timestamp}] postgres[{pid}]: database system is ready to accept connections",
        tags = {"postgres", "database"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768),
            version = string.format("PostgreSQL %d.%d", ctx.random.int(12, 15), ctx.random.int(0, 5))
        }
    end
}
