return {
    metadata = {
        name = "kernel.kext_load",
        category = "KERNEL",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Kernel extension loaded",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: Loaded kext {kext_name} (version {version})",
        tags = {"kernel", "kext", "driver"},
        merge_groups = {"kext_lifecycle"}
    },
    generate = function(ctx, args)
        local kexts = ctx.data.kernel.kext_names or {"com.apple.driver.AppleHDA"}
        return {
            process = "kernel",
            pid = 0,
            level = "Notice",
            subsystem = "com.apple.kernel",
            category = "kext",
            kext_name = ctx.random.choice(kexts),
            version = string.format("%d.%d.%d", ctx.random.int(1, 20), ctx.random.int(0, 9), ctx.random.int(0, 99))
        }
    end
}
