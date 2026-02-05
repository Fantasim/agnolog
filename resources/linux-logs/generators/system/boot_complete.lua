-- System Boot Complete Generator
-- Generates boot sequence completion log entries

return {
    metadata = {
        name = "system.boot_complete",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "Boot sequence completed",
        text_template = "[{timestamp}] systemd[1]: Startup finished in {firmware_time}s (firmware) + {loader_time}s (loader) + {kernel_time}s (kernel) + {userspace_time}s (userspace) = {total_time}s",
        tags = {"boot", "systemd", "system"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        local limits = ctx.data.constants.system_limits.boot or {}
        local firmware = ctx.random.int(2, 10)
        local loader = ctx.random.int(1, 5)
        local kernel = ctx.random.int(3, 15)
        local userspace = ctx.random.int(limits.typical_boot_time_min_sec or 5, limits.typical_boot_time_max_sec or 60)

        return {
            firmware_time = string.format("%d.%03d", firmware, ctx.random.int(0, 999)),
            loader_time = string.format("%d.%03d", loader, ctx.random.int(0, 999)),
            kernel_time = string.format("%d.%03d", kernel, ctx.random.int(0, 999)),
            userspace_time = string.format("%d.%03d", userspace, ctx.random.int(0, 999)),
            total_time = string.format("%d.%03d", firmware + loader + kernel + userspace, ctx.random.int(0, 999))
        }
    end
}
