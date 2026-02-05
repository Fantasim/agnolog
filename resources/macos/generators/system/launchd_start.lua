-- System Launchd Start Generator
-- Generates launchd daemon startup log entries

return {
    metadata = {
        name = "system.launchd_start",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Launchd starting daemon or service",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Starting service {daemon} (pid {daemon_pid})",
        tags = {"system", "launchd", "daemon", "lifecycle"},
        merge_groups = {"daemon_lifecycle"}
    },

    generate = function(ctx, args)
        local daemons = ctx.data.system.daemons or {"com.apple.example"}

        return {
            process = "launchd",
            pid = 1,
            level = "Notice",
            subsystem = "com.apple.launchd",
            category = "service",
            daemon = ctx.random.choice(daemons),
            daemon_pid = ctx.random.int(100, 65535),
            path = "/System/Library/LaunchDaemons/" .. ctx.random.choice(daemons) .. ".plist",
            throttle_interval = ctx.random.choice({0, 10, 60}),
            previous_exit_code = ctx.random.weighted({0, -1, 1}, {0.95, 0.03, 0.02})
        }
    end
}
