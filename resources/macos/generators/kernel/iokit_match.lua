return {
    metadata = {
        name = "kernel.iokit_match",
        category = "KERNEL",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "IOKit device matched",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: IOKit matched device {device_class}",
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
