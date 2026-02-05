-- USB Device Disconnect Generator
-- Generates USB device disconnection log entries

return {
    metadata = {
        name = "system.usb_device_disconnect",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "USB device disconnected",
        text_template = "[{timestamp}] kernel: usb {bus}-{port}: USB disconnect, device number {device_num}",
        tags = {"usb", "device", "hardware"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            bus = ctx.random.int(1, 4),
            port = ctx.random.int(1, 8),
            device_num = ctx.random.int(1, 127)
        }
    end
}
