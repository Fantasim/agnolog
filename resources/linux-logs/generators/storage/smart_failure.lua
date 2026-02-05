-- SMART Failure Generator
-- Generates SMART failure prediction log entries

return {
    metadata = {
        name = "storage.smart_failure",
        category = "STORAGE",
        severity = "CRITICAL",
        recurrence = "RARE",
        description = "SMART failure",
        text_template = "[{timestamp}] smartd[{pid}]: Device {device} FAILING: {failure_type}",
        tags = {"storage", "smart", "failure"},
        merge_groups = {"storage_health"}
    },

    generate = function(ctx, args)
        local devices = ctx.data.hardware.devices.block_devices or {"sda", "sdb"}
        local failure_types = {
            "too many bad sectors",
            "SMART overall-health self-assessment test failed",
            "reallocated sector count too high",
            "pending sector count too high"
        }

        return {
            pid = ctx.random.int(500, 5000),
            device = "/dev/" .. ctx.random.choice(devices),
            failure_type = ctx.random.choice(failure_types)
        }
    end
}
