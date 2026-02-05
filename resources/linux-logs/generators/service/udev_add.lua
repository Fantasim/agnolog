-- Udev Add Generator
-- Generates udev device add log entries

return {
    metadata = {
        name = "service.udev_add",
        category = "SERVICE",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Udev device added",
        text_template = "[{timestamp}] systemd-udevd[{pid}]: {device}: Device node created",
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
