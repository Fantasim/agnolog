-- Filesystem Mount Generator
-- Generates filesystem mount log entries

return {
    metadata = {
        name = "storage.mount",
        category = "STORAGE",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Filesystem mounted",
        text_template = "[{timestamp}] systemd[1]: Mounted {mount_point}",
        tags = {"storage", "filesystem", "mount"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local mount_points = ctx.data.filesystem.paths.mount_points or {"/", "/home", "/var"}
        local mount_types = ctx.data.filesystem.paths.mount_types or {"ext4", "xfs", "nfs"}

        return {
            mount_point = ctx.random.choice(mount_points),
            device = "/dev/" .. ctx.random.choice(ctx.data.hardware.devices.block_devices or {"sda1"}),
            fs_type = ctx.random.choice(mount_types)
        }
    end
}
