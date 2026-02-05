-- SSH Login Failure Generator
-- Generates failed SSH login log entries

return {
    metadata = {
        name = "auth.ssh_login_failure",
        category = "AUTH",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Failed SSH login",
        text_template = "[{timestamp}] sshd[{pid}]: Failed {method} for {user} from {ip} port {port} ssh2",
        tags = {"auth", "ssh", "failure"},
        merge_groups = {"auth_failures"}
    },

    generate = function(ctx, args)
        local auth_methods = ctx.data.users.authentication.auth_methods or {"password", "publickey"}
        local failure_reasons = ctx.data.users.authentication.failure_reasons or {"Failed password", "Invalid user"}

        return {
            user = ctx.gen.player_name(),
            method = ctx.random.choice(auth_methods),
            ip = ctx.gen.ip_address(),
            port = ctx.random.int(1024, 65535),
            pid = ctx.random.int(1000, 32768),
            reason = ctx.random.choice(failure_reasons),
            attempts = ctx.random.int(1, 6)
        }
    end
}
