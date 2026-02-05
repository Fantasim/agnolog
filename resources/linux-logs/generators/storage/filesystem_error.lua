-- Filesystem Error Generator
-- Generates filesystem error log entries

return {
    metadata = {
        name = "storage.filesystem_error",
        category = "STORAGE",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Filesystem error",
        text_template = "[{timestamp}] kernel: EXT4-fs error (device {device}): {function}: {error_message}",
        tags = {"storage", "filesystem", "error"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local devices = ctx.data.hardware.devices.block_devices or {"sda1"}
        local functions = {"ext4_mb_generate_buddy", "ext4_find_entry", "ext4_ext_check_inode"}
        local errors = {
            "inode bitmap corruption detected",
            "block bitmap and bg descriptor inconsistent",
            "Directory index full",
            "corrupt journal",
            "unable to read itable block"
        }

        return {
            device = ctx.random.choice(devices),
            function_name = ctx.random.choice(functions),
            error_message = ctx.random.choice(errors)
        }
    end
}
