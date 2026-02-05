-- Watchdog Timeout Generator
-- Generates watchdog timeout log entries

return {
    metadata = {
        name = "system.watchdog_timeout",
        category = "SYSTEM",
        severity = "CRITICAL",
        recurrence = "RARE",
        description = "Watchdog timeout",
        text_template = "[{timestamp}] kernel: watchdog: BUG: soft lockup - CPU#{cpu_id} stuck for {seconds}s! [{process}:{pid}]",
        tags = {"watchdog", "lockup", "kernel"},
        merge_groups = {"system_errors"}
    },

    generate = function(ctx, args)
        local processes = {"kworker", "systemd", "mysqld", "apache2", "nginx"}

        return {
            cpu_id = ctx.random.int(0, 15),
            seconds = ctx.random.int(21, 120),
            process = ctx.random.choice(processes),
            pid = ctx.random.int(1, 32768)
        }
    end
}
