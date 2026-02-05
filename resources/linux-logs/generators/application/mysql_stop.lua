-- MySQL Stop Generator
-- Generates MySQL stop log entries

return {
    metadata = {
        name = "application.mysql_stop",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "MySQL stopped",
        text_template = "[{timestamp}] mysqld[{pid}]: Shutdown complete",
        tags = {"mysql", "database"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768),
            uptime_seconds = ctx.random.int(3600, 2592000)
        }
    end
}
