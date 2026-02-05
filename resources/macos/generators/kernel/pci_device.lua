return {
    metadata = {
        name = "kernel.pci_device",
        category = "KERNEL",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "PCI device event",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: PCI device {device_id} {action}",
        tags = {"kernel", "pci", "device"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {
            process = "kernel",
            pid = 0,
            level = "Default",
            subsystem = "com.apple.kernel",
            category = "pci",
            device_id = string.format("%02x:%02x.%d", ctx.random.int(0, 255), ctx.random.int(0, 31), ctx.random.int(0, 7)),
            action = ctx.random.choice({"detected", "configured", "removed"})
        }
    end
}
