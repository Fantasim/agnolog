-- PostgreSQL Checkpoint Generator
-- Generates PostgreSQL checkpoint log entries

return {
    metadata = {
        name = "application.postgres_checkpoint",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "PostgreSQL checkpoint",
        text_template = "[{timestamp}] postgres[{pid}]: checkpoint complete: wrote {buffers} buffers ({percent}%); {wal_files} WAL file(s) added, {wal_removed} removed, {wal_recycled} recycled",
        tags = {"postgres", "database"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local buffers = ctx.random.int(100, 10000)

        return {
            pid = ctx.random.int(1000, 32768),
            buffers = buffers,
            percent = string.format("%.1f", ctx.random.float(0.1, 10.0)),
            wal_files = ctx.random.int(0, 5),
            wal_removed = ctx.random.int(0, 3),
            wal_recycled = ctx.random.int(0, 2)
        }
    end
}
