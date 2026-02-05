return {
    metadata = {
        name = "kernel.vm_compressor",
        category = "KERNEL",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "VM compressor activity",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: VM compressor {action} {pages_count} pages",
        tags = {"kernel", "memory", "compressor"},
        merge_groups = {"memory_events"}
    },
    generate = function(ctx, args)
        return {
            process = "kernel",
            pid = 0,
            level = "Debug",
            subsystem = "com.apple.kernel",
            category = "vm",
            action = ctx.random.choice({"compressed", "decompressed"}),
            pages_count = ctx.random.int(10, 10000)
        }
    end
}
