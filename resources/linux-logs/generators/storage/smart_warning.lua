-- SMART Warning Generator
-- Generates SMART attribute warning log entries

return {
    metadata = {
        name = "storage.smart_warning",
        category = "STORAGE",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "SMART warning",
        text_template = "[{timestamp}] smartd[{pid}]: Device {device} has {attribute} warning threshold exceeded (value: {value})",
        tags = {"storage", "smart", "health"},
        merge_groups = {"storage_health"}
    },

    generate = function(ctx, args)
        local devices = ctx.data.hardware.devices.block_devices or {"sda", "sdb"}
        local attributes = ctx.data.hardware.sensors.smart_attributes or {"Reallocated_Sector_Ct", "Current_Pending_Sector"}

        return {
            pid = ctx.random.int(500, 5000),
            device = "/dev/" .. ctx.random.choice(devices),
            attribute = ctx.random.choice(attributes),
            value = ctx.random.int(1, 100)
        }
    end
}
