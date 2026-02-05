-- USB Device Connect Generator
-- Generates USB device connection log entries

return {
    metadata = {
        name = "system.usb_device_connect",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "USB device connected",
        text_template = "[{timestamp}] kernel: usb {bus}-{port}: new {speed} USB device number {device_num} using {controller}",
        tags = {"usb", "device", "hardware"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local speeds = {"low-speed", "full-speed", "high-speed", "super-speed"}
        local controllers = {"xhci_hcd", "ehci_hcd", "ohci_hcd", "uhci_hcd"}

        return {
            bus = ctx.random.int(1, 4),
            port = ctx.random.int(1, 8),
            speed = ctx.random.choice(speeds),
            device_num = ctx.random.int(1, 127),
            controller = ctx.random.choice(controllers),
            vendor_id = string.format("%04x", ctx.random.int(0, 65535)),
            product_id = string.format("%04x", ctx.random.int(0, 65535))
        }
    end
}
