-- Technical Connection Open Generator
-- Generates connection established log entries

return {
    metadata = {
        name = "technical.connection_open",
        category = "TECHNICAL",
        severity = "DEBUG",
        recurrence = "NORMAL",
        description = "Network connection established",
        text_template = "[{timestamp}] CONN OPEN: {ip}:{port} protocol:{protocol}",
        tags = {"network", "connection"},
        merge_groups = {"connections"}
    },

    generate = function(ctx, args)
        local protocols = {"TCP", "UDP", "WebSocket"}

        -- Get latency bounds from data
        local min_latency = 10
        local typical_latency = 50
        if ctx.data.constants and ctx.data.constants.network and ctx.data.constants.network.latency then
            min_latency = ctx.data.constants.network.latency.min_ms or 10
            typical_latency = ctx.data.constants.network.latency.typical_ms or 50
        end

        return {
            connection_id = ctx.gen.hex_string(16),
            ip = args.ip or ctx.gen.ip_address(),
            port = ctx.random.int(1024, 65535),
            protocol = ctx.random.choice(protocols),
            latency_ms = ctx.random.int(min_latency, typical_latency * 2),
            encryption = ctx.random.choice({"TLS1.3", "TLS1.2", "none"}),
            client_version = string.format("1.%d.%d", ctx.random.int(0, 5), ctx.random.int(0, 20))
        }
    end
}
