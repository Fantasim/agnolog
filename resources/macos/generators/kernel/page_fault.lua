return {
    metadata = {
        name = "kernel.page_fault",
        category = "KERNEL",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Page fault",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: Page fault at address {address}",
        tags = {"kernel", "memory", "pagefault"},
        merge_groups = {"memory_events"}
    },
    generate = function(ctx, args)
        return {
            process = "kernel",
            pid = 0,
            level = "Debug",
            subsystem = "com.apple.kernel",
            category = "vm",
            address = string.format("0x%016x", ctx.random.int(0, 0xFFFFFFFF))
        }
    end
}
