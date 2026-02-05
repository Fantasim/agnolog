-- Slow I/O Generator
-- Generates slow I/O warning log entries

return {
    metadata = {
        name = "storage.io_slow",
        category = "STORAGE",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Slow I/O detected",
        text_template = "[{timestamp}] kernel: {device}: I/O latency {latency}ms exceeds threshold",
        tags = {"storage", "performance", "io"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local devices = ctx.data.hardware.devices.block_devices or {"sda"}
        local limits = ctx.data.constants.system_limits.disk or {}

        return {
            device = "/dev/" .. ctx.random.choice(devices),
            latency = ctx.random.int(limits.io_latency_warning_ms or 100, limits.io_latency_critical_ms or 500)
        }
    end
}
