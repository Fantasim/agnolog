-- SELinux Mode Change Generator
-- Generates SELinux mode change log entries

return {
    metadata = {
        name = "security.selinux_mode_change",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "RARE",
        description = "SELinux mode changed",
        text_template = "[{timestamp}] kernel: SELinux: switched to {mode} mode",
        tags = {"selinux", "security"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local modes = ctx.data.security.security_modules.selinux_modes or {"enforcing", "permissive"}

        return {
            mode = ctx.random.choice(modes),
            previous_mode = ctx.random.choice(modes)
        }
    end
}
