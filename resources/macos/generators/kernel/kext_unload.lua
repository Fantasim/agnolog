return {
    metadata = {
        name = "kernel.kext_unload",
        category = "KERNEL",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Kernel extension unloaded",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: Unloaded kext {kext_name}",
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
            kext_name = ctx.random.choice(kexts)
        }
    end
}
