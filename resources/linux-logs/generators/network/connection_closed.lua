-- Connection Closed Generator
-- Generates TCP connection closed log entries

return {
    metadata = {
        name = "network.connection_closed",
        category = "NETWORK",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "TCP connection closed",
        text_template = "[{timestamp}] kernel: TCP: {local_ip}:{local_port} connection closed",
        tags = {"network", "tcp", "connection"},
        merge_groups = {"network_connections"}
    },

    generate = function(ctx, args)
        return {
            local_ip = ctx.gen.ip_address(),
            local_port = ctx.random.int(1024, 65535),
            duration_seconds = ctx.random.int(1, 7200)
        }
    end
}
