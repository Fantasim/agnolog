-- Filesystem Unmount Generator
-- Generates filesystem unmount log entries

return {
    metadata = {
        name = "storage.unmount",
        category = "STORAGE",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Filesystem unmounted",
        text_template = "[{timestamp}] systemd[1]: Unmounting {mount_point}...",
        tags = {"storage", "filesystem", "mount"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local mount_points = ctx.data.filesystem.paths.mount_points or {"/mnt/data", "/media/usb"}

        return {
            mount_point = ctx.random.choice(mount_points)
        }
    end
}
