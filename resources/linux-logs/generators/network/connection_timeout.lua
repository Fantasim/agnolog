-- Connection Timeout Generator
-- Generates TCP connection timeout log entries

return {
    metadata = {
        name = "network.connection_timeout",
        category = "NETWORK",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Connection timeout",
        text_template = "[{timestamp}] kernel: TCP: {local_ip}:{local_port} timeout to {remote_ip}:{remote_port}",
        tags = {"network", "tcp", "timeout"},
        merge_groups = {"network_connections"}
    },

    generate = function(ctx, args)
        return {
            local_ip = ctx.gen.ip_address(),
            local_port = ctx.random.int(1024, 65535),
            remote_ip = ctx.gen.ip_address(),
            remote_port = ctx.random.int(1, 65535)
        }
    end
}
