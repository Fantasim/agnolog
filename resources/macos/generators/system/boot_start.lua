-- System Boot Start Generator
-- Generates system boot initiated log entries

return {
    metadata = {
        name = "system.boot_start",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "System boot initiated",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: System boot initiated, build {build_version}",
        tags = {"system", "boot", "kernel"},
        merge_groups = {"power_events"}
    },

    generate = function(ctx, args)
        local versions = ctx.data.system.system_versions.versions or {{name = "Sonoma", version = "14.0"}}
        local version_data = ctx.random.choice(versions)

        return {
            process = "kernel",
            pid = 0,
            level = "Notice",
            subsystem = "com.apple.kernel",
            category = "boot",
            build_version = version_data.version .. "." .. ctx.random.int(1, 9),
            boot_mode = ctx.random.choice({"Normal", "Safe", "Verbose", "Single User"}),
            boot_args = ctx.random.choice({"", "-v", "-s", "-x"}),
            secure_boot_level = ctx.random.choice({"Full", "Medium", "None"})
        }
    end
}
