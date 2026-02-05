-- System Launchd Stop Generator
-- Generates launchd daemon stop log entries

return {
    metadata = {
        name = "system.launchd_stop",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Launchd stopping daemon or service",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Service {daemon} exited with code {exit_code}",
        tags = {"system", "launchd", "daemon", "lifecycle"},
        merge_groups = {"daemon_lifecycle"}
    },

    generate = function(ctx, args)
        local daemons = ctx.data.system.daemons or {"com.apple.example"}

        return {
            process = "launchd",
            pid = 1,
            level = ctx.random.choice({"Default", "Notice", "Error"}),
            subsystem = "com.apple.launchd",
            category = "service",
            daemon = ctx.random.choice(daemons),
            daemon_pid = ctx.random.int(100, 65535),
            exit_code = ctx.random.weighted({0, -1, 1, 9, 15}, {0.90, 0.03, 0.02, 0.03, 0.02}),
            reason = ctx.random.choice({"normal shutdown", "killed", "crashed", "user requested"})
        }
    end
}
