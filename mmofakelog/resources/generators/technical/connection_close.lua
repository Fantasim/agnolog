-- Technical Connection Close Generator

return {
    metadata = {
        name = "technical.connection_close",
        category = "TECHNICAL",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Connection closed",
        text_template = "[{timestamp}] CONN_CLOSE: {client_ip}:{port} (reason: {reason}, duration: {duration}s)",
        tags = {"technical", "network", "connection"}
    },

    generate = function(ctx, args)
        local reasons = {
            "client_disconnect", "server_close", "timeout", "error",
            "kick", "maintenance", "handoff"
        }

        return {
            client_ip = ctx.gen.ip_address(),
            port = ctx.random.int(1024, 65535),
            reason = ctx.random.choice(reasons),
            duration = ctx.random.int(1, 28800),
            bytes_sent = ctx.random.int(1000, 100000000),
            bytes_received = ctx.random.int(1000, 50000000),
            packets_sent = ctx.random.int(100, 1000000),
            packets_received = ctx.random.int(100, 500000)
        }
    end
}
