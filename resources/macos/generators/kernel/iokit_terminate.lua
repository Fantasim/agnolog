return {
    metadata = {
        name = "kernel.iokit_terminate",
        category = "KERNEL",
        severity = "DEBUG",
        recurrence = "NORMAL",
        description = "IOKit device terminated",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: IOKit terminated device {device_class}",
        tags = {"kernel", "iokit", "device"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local classes = ctx.data.kernel.iokit_classes or {"IOUSBDevice", "IOPCIDevice"}
        return {
            process = "kernel",
            pid = 0,
            level = "Debug",
            subsystem = "com.apple.iokit",
            category = "device",
            device_class = ctx.random.choice(classes)
        }
    end
}
