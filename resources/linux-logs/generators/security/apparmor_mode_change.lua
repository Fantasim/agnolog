-- AppArmor Mode Change Generator
-- Generates AppArmor mode change log entries

return {
    metadata = {
        name = "security.apparmor_mode_change",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "RARE",
        description = "AppArmor mode changed",
        text_template = "[{timestamp}] apparmor[{pid}]: Reloaded AppArmor profiles",
        tags = {"apparmor", "security"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(100, 5000),
            profiles_loaded = ctx.random.int(10, 50)
        }
    end
}
