-- LVM Extend Generator
-- Generates LVM volume extension log entries

return {
    metadata = {
        name = "storage.lvm_extend",
        category = "STORAGE",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "LVM volume extended",
        text_template = "[{timestamp}] lvm[{pid}]: Volume {volume} extended from {old_size}GB to {new_size}GB",
        tags = {"storage", "lvm"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local old_size = ctx.random.int(10, 500)
        local increase = ctx.random.int(10, 200)

        return {
            pid = ctx.random.int(1000, 32768),
            volume = "/dev/mapper/vg0-lv_" .. ctx.random.choice({"root", "home", "var", "data"}),
            old_size = old_size,
            new_size = old_size + increase
        }
    end
}
