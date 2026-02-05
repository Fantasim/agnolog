-- System Daemon Crash Generator
-- Generates daemon crash log entries

return {
    metadata = {
        name = "system.daemon_crash",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Daemon crashed unexpectedly",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Service {daemon} crashed with signal {signal}",
        tags = {"system", "crash", "daemon", "error"},
        merge_groups = {"daemon_lifecycle"}
    },

    generate = function(ctx, args)
        local daemons = ctx.data.system.daemons or {"com.apple.example"}

        return {
            process = "launchd",
            pid = 1,
            level = "Error",
            subsystem = "com.apple.launchd",
            category = "crash",
            daemon = ctx.random.choice(daemons),
            daemon_pid = ctx.random.int(100, 65535),
            signal = ctx.random.choice({"SIGSEGV", "SIGBUS", "SIGILL", "SIGABRT", "SIGFPE"}),
            crash_count = ctx.random.int(1, 5),
            will_respawn = ctx.random.choice({true, false})
        }
    end
}
