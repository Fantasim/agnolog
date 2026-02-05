-- Udev Remove Generator
-- Generates udev device remove log entries

return {
    metadata = {
        name = "service.udev_remove",
        category = "SERVICE",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Udev device removed",
        text_template = "[{timestamp}] systemd-udevd[{pid}]: {device}: Device node removed",
        tags = {"udev", "device"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local devices = ctx.data.hardware.devices.block_devices or {"sda", "sdb"}

        return {
            pid = ctx.random.int(100, 1000),
            device = "/dev/" .. ctx.random.choice(devices)
        }
    end
}
