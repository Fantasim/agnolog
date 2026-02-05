-- RAID Rebuild Complete Generator
-- Generates RAID rebuild completion log entries

return {
    metadata = {
        name = "storage.raid_rebuild_complete",
        category = "STORAGE",
        severity = "INFO",
        recurrence = "RARE",
        description = "RAID rebuild completed",
        text_template = "[{timestamp}] kernel: md{raid_num}: recovery done",
        tags = {"storage", "raid", "recovery"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            raid_num = ctx.random.int(0, 9),
            duration_minutes = ctx.random.int(30, 720)
        }
    end
}
