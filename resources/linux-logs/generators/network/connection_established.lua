-- Connection Established Generator
-- Generates TCP connection established log entries

return {
    metadata = {
        name = "network.connection_established",
        category = "NETWORK",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "TCP connection opened",
        text_template = "[{timestamp}] kernel: TCP: {local_ip}:{local_port} -> {remote_ip}:{remote_port} state ESTABLISHED",
        tags = {"network", "tcp", "connection"},
        merge_groups = {"network_connections"}
    },

    generate = function(ctx, args)
        local ports = ctx.data.network.protocols.common_ports or {}
        local port_list = {}
        for _, port in pairs(ports) do
            table.insert(port_list, port)
        end

        return {
            local_ip = ctx.gen.ip_address(),
            local_port = ctx.random.int(1024, 65535),
            remote_ip = ctx.gen.ip_address(),
            remote_port = #port_list > 0 and ctx.random.choice(port_list) or ctx.random.int(1, 65535)
        }
    end
}
