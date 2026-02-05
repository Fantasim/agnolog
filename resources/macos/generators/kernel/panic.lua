return {
    metadata = {
        name = "kernel.panic",
        category = "KERNEL",
        severity = "CRITICAL",
        recurrence = "RARE",
        description = "Kernel panic",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: panic: {reason}",
        tags = {"kernel", "panic", "crash"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local reasons = {
            "Kernel trap",
            "Double fault",
            "Page fault in kernel mode",
            "Assertion failed",
            "Deadlock detected"
        }
        return {
            process = "kernel",
            pid = 0,
            level = "Fault",
            subsystem = "com.apple.kernel",
            category = "panic",
            reason = ctx.random.choice(reasons)
        }
    end
}
