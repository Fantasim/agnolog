-- RAID Rebuild Start Generator
-- Generates RAID rebuild start log entries

return {
    metadata = {
        name = "storage.raid_rebuild_start",
        category = "STORAGE",
        severity = "INFO",
        recurrence = "RARE",
        description = "RAID rebuild started",
        text_template = "[{timestamp}] kernel: md{raid_num}: recovery started",
        tags = {"storage", "raid", "recovery"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            raid_num = ctx.random.int(0, 9),
            device_count = ctx.random.int(2, 6)
        }
    end
}
