return {
    metadata = {
        name = "kernel.cpu_throttle",
        category = "KERNEL",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "CPU throttling",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: CPU throttled to {percentage}%",
        tags = {"kernel", "cpu", "throttle"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {
            process = "kernel",
            pid = 0,
            level = "Default",
            subsystem = "com.apple.kernel",
            category = "cpu",
            percentage = ctx.random.int(20, 80),
            reason = ctx.random.choice({"thermal", "power", "battery"})
        }
    end
}
