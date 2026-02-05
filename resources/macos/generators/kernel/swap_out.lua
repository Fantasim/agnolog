return {
    metadata = {
        name = "kernel.swap_out",
        category = "KERNEL",
        severity = "DEBUG",
        recurrence = "NORMAL",
        description = "Swap out event",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: Swapped out {pages_count} pages",
        tags = {"kernel", "memory", "swap"},
        merge_groups = {"memory_events"}
    },
    generate = function(ctx, args)
        return {
            process = "kernel",
            pid = 0,
            level = "Debug",
            subsystem = "com.apple.kernel",
            category = "vm",
            pages_count = ctx.random.int(1, 1000)
        }
    end
}
