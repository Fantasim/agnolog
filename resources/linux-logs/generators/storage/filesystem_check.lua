-- Filesystem Check Generator
-- Generates filesystem check log entries

return {
    metadata = {
        name = "storage.filesystem_check",
        category = "STORAGE",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Filesystem check run",
        text_template = "[{timestamp}] fsck[{pid}]: {device}: clean, {files} files, {blocks} blocks",
        tags = {"storage", "filesystem", "fsck"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local devices = ctx.data.hardware.devices.block_devices or {"sda1", "sda2"}

        return {
            pid = ctx.random.int(100, 1000),
            device = "/dev/" .. ctx.random.choice(devices),
            files = ctx.random.int(10000, 1000000),
            blocks = ctx.random.int(1000000, 100000000)
        }
    end
}
