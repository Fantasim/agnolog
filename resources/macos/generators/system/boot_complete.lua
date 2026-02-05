-- System Boot Complete Generator
-- Generates boot completed log entries

return {
    metadata = {
        name = "system.boot_complete",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "System boot completed",
        text_template = "{timestamp} launchd[1] <{level}>: {subsystem} {category}: Boot complete in {boot_time_sec}s",
        tags = {"system", "boot", "launchd"},
        merge_groups = {"power_events"}
    },

    generate = function(ctx, args)
        return {
            process = "launchd",
            pid = 1,
            level = "Default",
            subsystem = "com.apple.launchd",
            category = "boot",
            boot_time_sec = ctx.random.int(15, 120),
            kernel_boot_time = ctx.random.int(2, 10),
            userspace_boot_time = ctx.random.int(10, 60),
            daemons_started = ctx.random.int(50, 150)
        }
    end
}
