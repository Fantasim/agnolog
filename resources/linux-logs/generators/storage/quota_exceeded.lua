-- Quota Exceeded Generator
-- Generates disk quota exceeded log entries

return {
    metadata = {
        name = "storage.quota_exceeded",
        category = "STORAGE",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Disk quota exceeded",
        text_template = "[{timestamp}] kernel: quota: user {user} exceeded quota on {device} ({used}MB used, limit {limit}MB)",
        tags = {"storage", "quota"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local devices = ctx.data.hardware.devices.block_devices or {"sda1"}
        local limit = ctx.random.int(1000, 50000)

        return {
            user = ctx.gen.player_name(),
            device = "/dev/" .. ctx.random.choice(devices),
            used = limit + ctx.random.int(1, 1000),
            limit = limit
        }
    end
}
