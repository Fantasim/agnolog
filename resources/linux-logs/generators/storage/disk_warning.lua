-- Disk Warning Generator
-- Generates disk space warning log entries

return {
    metadata = {
        name = "storage.disk_warning",
        category = "STORAGE",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Disk space low",
        text_template = "[{timestamp}] disk-monitor: {mount_point} at {percent}% capacity ({used_gb}GB used of {total_gb}GB)",
        tags = {"storage", "disk", "warning"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local mount_points = ctx.data.filesystem.paths.mount_points or {"/", "/var", "/home"}
        local limits = ctx.data.constants.system_limits.disk or {}
        local percent = ctx.random.int(limits.warning_threshold_percent or 85, limits.critical_threshold_percent or 95)

        return {
            mount_point = ctx.random.choice(mount_points),
            percent = percent,
            used_gb = ctx.random.int(50, 900),
            total_gb = ctx.random.int(100, 1000)
        }
    end
}
