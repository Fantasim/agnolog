-- Disk Full Generator
-- Generates disk full error log entries

return {
    metadata = {
        name = "storage.disk_full",
        category = "STORAGE",
        severity = "CRITICAL",
        recurrence = "INFREQUENT",
        description = "Disk space critical",
        text_template = "[{timestamp}] kernel: {filesystem}: no space left on device",
        tags = {"storage", "disk", "critical"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local mount_points = ctx.data.filesystem.paths.mount_points or {"/", "/var"}

        return {
            filesystem = ctx.random.choice(mount_points),
            used_percent = ctx.random.int(98, 100)
        }
    end
}
