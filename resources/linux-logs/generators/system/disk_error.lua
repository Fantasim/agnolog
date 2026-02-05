-- Disk Error Generator
-- Generates disk I/O error log entries

return {
    metadata = {
        name = "system.disk_error",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Disk I/O error",
        text_template = "[{timestamp}] kernel: {operation} error, dev {device}, sector {sector} op 0x{op_code}:({op_name}) flags 0x{flags}",
        tags = {"disk", "io", "error"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local devices = ctx.data.hardware.devices.block_devices or {"sda", "sdb", "nvme0n1"}
        local operations = {"I/O", "Read", "Write"}
        local op_names = {"READ", "WRITE", "FLUSH", "DISCARD"}

        return {
            operation = ctx.random.choice(operations),
            device = ctx.random.choice(devices),
            sector = ctx.random.int(0, 4000000000),
            op_code = ctx.random.int(0, 9),
            op_name = ctx.random.choice(op_names),
            flags = ctx.random.int(0, 800)
        }
    end
}
