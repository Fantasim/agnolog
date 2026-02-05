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
        local exit_code = ctx.random.float(0, 1) < 0.90 and 0 or ctx.random.choice({-1, 1, 9, 15})
        
        return {
            process = "launchd",
            pid = 1,
            level = ctx.random.choice({"Default", "Notice", "Error"}),
            subsystem = "com.apple.launchd",
            category = "service",
            daemon = ctx.random.choice(daemons),
            daemon_pid = ctx.random.int(100, 65535),
            exit_code = exit_code,
            reason = ctx.random.choice({"normal shutdown", "killed", "crashed", "user requested"})
        }
    end
}
