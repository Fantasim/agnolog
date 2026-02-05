-- System Daemon Respawn Generator
-- Generates daemon respawn log entries

return {
    metadata = {
        name = "system.daemon_respawn",
        category = "SYSTEM",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Daemon respawned after crash",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Respawning service {daemon} after {crash_count} crash(es)",
        tags = {"system", "launchd", "daemon", "respawn"},
        merge_groups = {"daemon_lifecycle"}
    },

    generate = function(ctx, args)
        local daemons = ctx.data.system.daemons or {"com.apple.example"}

        return {
            process = "launchd",
            pid = 1,
            level = "Default",
            subsystem = "com.apple.launchd",
            category = "respawn",
            daemon = ctx.random.choice(daemons),
            new_pid = ctx.random.int(100, 65535),
            crash_count = ctx.random.int(1, 10),
            throttle_delay = ctx.random.choice({0, 10, 30, 60}),
            max_crashes = ctx.random.int(5, 10)
        }
    end
}
