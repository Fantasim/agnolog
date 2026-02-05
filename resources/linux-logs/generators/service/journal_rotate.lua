-- Journal Rotate Generator
-- Generates journal log rotation log entries

return {
    metadata = {
        name = "service.journal_rotate",
        category = "SERVICE",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Journal log rotated",
        text_template = "[{timestamp}] systemd-journald[{pid}]: Runtime Journal is using {size}M (max allowed {max_size}M)",
        tags = {"journal", "systemd"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(100, 1000),
            size = ctx.random.int(8, 4096),
            max_size = ctx.random.int(4096, 8192),
            files = ctx.random.int(1, 100)
        }
    end
}
