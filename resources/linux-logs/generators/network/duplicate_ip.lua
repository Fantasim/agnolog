-- Duplicate IP Generator
-- Generates duplicate IP detection log entries

return {
    metadata = {
        name = "network.duplicate_ip",
        category = "NETWORK",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Duplicate IP detected",
        text_template = "[{timestamp}] kernel: IPv4: {interface}: duplicate address {ip} detected!",
        tags = {"network", "ip", "conflict"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local interfaces = ctx.data.network.protocols.interfaces or {"eth0"}

        return {
            interface = ctx.random.choice(interfaces),
            ip = ctx.gen.ip_address()
        }
    end
}
