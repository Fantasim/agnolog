return {
    metadata = {
        name = "kernel.usb_attach",
        category = "KERNEL",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "USB device attached",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: USB device attached on port {port}",
        tags = {"kernel", "usb", "device"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {
            process = "kernel",
            pid = 0,
            level = "Default",
            subsystem = "com.apple.kernel",
            category = "usb",
            port = ctx.random.int(1, 8),
            device_id = string.format("%04x:%04x", ctx.random.int(0x0001, 0xFFFF), ctx.random.int(0x0001, 0xFFFF))
        }
    end
}
