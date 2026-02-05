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
        local exit_code = ctx.random.float(0, 1) < 0.95 and 0 or ctx.random.choice({-1, 1})
        
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
            previous_exit_code = exit_code
        }
    end
}
