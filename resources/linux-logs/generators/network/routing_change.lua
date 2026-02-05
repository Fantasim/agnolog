-- Routing Change Generator
-- Generates routing table change log entries

return {
    metadata = {
        name = "network.routing_change",
        category = "NETWORK",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Routing table changed",
        text_template = "[{timestamp}] kernel: IPv4: {interface}: new route to {network}/{prefix} via {gateway}",
        tags = {"network", "routing"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local interfaces = ctx.data.network.protocols.interfaces or {"eth0"}

        return {
            interface = ctx.random.choice(interfaces),
            network = ctx.gen.ip_address(),
            prefix = ctx.random.choice({8, 16, 24}),
            gateway = ctx.gen.ip_address()
        }
    end
}
