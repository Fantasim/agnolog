-- Brute Force Detection Generator
-- Generates brute force attack detection log entries

return {
    metadata = {
        name = "auth.brute_force_detected",
        category = "AUTH",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Brute force detected",
        text_template = "[{timestamp}] sshd[{pid}]: reverse mapping checking getaddrinfo for {hostname} [{ip}] failed - POSSIBLE BREAK-IN ATTEMPT!",
        tags = {"auth", "security", "brute_force"},
        merge_groups = {"auth_failures"}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768),
            hostname = ctx.gen.hostname(),
            ip = ctx.gen.ip_address(),
            attempts = ctx.random.int(10, 100)
        }
    end
}
