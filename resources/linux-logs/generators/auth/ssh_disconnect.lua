-- SSH Disconnect Generator
-- Generates SSH session closure log entries

return {
    metadata = {
        name = "auth.ssh_disconnect",
        category = "AUTH",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "SSH session closed",
        text_template = "[{timestamp}] sshd[{pid}]: Received disconnect from {ip} port {port}:{reason_code}: {reason}",
        tags = {"auth", "ssh", "session"},
        merge_groups = {"sessions"}
    },

    generate = function(ctx, args)
        local disconnect_reasons = ctx.data.users.authentication.disconnect_reasons or {
            "11: disconnected by user",
            "2: protocol error",
            "10: connection lost"
        }

        return {
            ip = ctx.gen.ip_address(),
            port = ctx.random.int(1024, 65535),
            pid = ctx.random.int(1000, 32768),
            reason_code = ctx.random.int(2, 14),
            reason = ctx.random.choice(disconnect_reasons),
            session_duration = ctx.random.int(1, 7200)
        }
    end
}
