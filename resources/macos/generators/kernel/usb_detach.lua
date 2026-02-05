return {
    metadata = {
        name = "kernel.usb_detach",
        category = "KERNEL",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "USB device detached",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: USB device detached from port {port}",
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
            port = ctx.random.int(1, 8)
        }
    end
}
