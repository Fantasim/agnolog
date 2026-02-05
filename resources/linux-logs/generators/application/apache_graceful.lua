-- Apache Graceful Restart Generator
-- Generates Apache graceful restart log entries

return {
    metadata = {
        name = "application.apache_graceful",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Apache graceful restart",
        text_template = "[{timestamp}] apache2[{pid}]: caught SIGUSR1, graceful restart",
        tags = {"apache", "web"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768)
        }
    end
}
