-- Apache Start Generator
-- Generates Apache start log entries

return {
    metadata = {
        name = "application.apache_start",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Apache started",
        text_template = "[{timestamp}] apache2[{pid}]: Apache/{version} configured -- resuming normal operations",
        tags = {"apache", "web"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768),
            version = string.format("2.4.%d", ctx.random.int(29, 52))
        }
    end
}
