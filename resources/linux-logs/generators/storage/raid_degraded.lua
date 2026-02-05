-- RAID Degraded Generator
-- Generates RAID array degraded log entries

return {
    metadata = {
        name = "storage.raid_degraded",
        category = "STORAGE",
        severity = "ERROR",
        recurrence = "RARE",
        description = "RAID array degraded",
        text_template = "[{timestamp}] kernel: md{raid_num}: Disk failure on {device}, disabling device. Operation continuing on {active} devices",
        tags = {"storage", "raid", "failure"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local devices = ctx.data.hardware.devices.block_devices or {"sda", "sdb", "sdc"}

        return {
            raid_num = ctx.random.int(0, 9),
            device = ctx.random.choice(devices),
            active = ctx.random.int(1, 5),
            total = ctx.random.int(2, 6)
        }
    end
}
