-- System Time Sync Generator
-- Generates time synchronization log entries

return {
    metadata = {
        name = "system.time_sync",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "System time synchronized",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Time synchronized with {ntp_server}, offset {offset_ms}ms",
        tags = {"system", "time", "ntp"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local ntp_servers = {
            "time.apple.com",
            "time.nist.gov",
            "pool.ntp.org",
            "time.google.com",
            "time.cloudflare.com"
        }

        return {
            process = "timed",
            pid = ctx.random.int(50, 500),
            level = "Default",
            subsystem = "com.apple.timed",
            category = "ntp",
            ntp_server = ctx.random.choice(ntp_servers),
            offset_ms = ctx.random.int(-500, 500),
            stratum = ctx.random.int(1, 4),
            precision_ms = ctx.random.float(0.1, 10.0)
        }
    end
}
