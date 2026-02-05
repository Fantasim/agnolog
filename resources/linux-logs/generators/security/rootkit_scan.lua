-- Rootkit Scan Generator
-- Generates rootkit scan completion log entries

return {
    metadata = {
        name = "security.rootkit_scan",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Rootkit scan completed",
        text_template = "[{timestamp}] rkhunter[{pid}]: Scan completed, {warnings} warning(s) found",
        tags = {"rootkit", "security", "scan"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(100, 32768),
            warnings = ctx.random.int(0, 5),
            files_checked = ctx.random.int(1000, 50000)
        }
    end
}
