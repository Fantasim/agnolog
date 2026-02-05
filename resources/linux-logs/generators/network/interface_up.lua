-- Network Interface Up Generator
-- Generates network interface up log entries

return {
    metadata = {
        name = "network.interface_up",
        category = "NETWORK",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Network interface up",
        text_template = "[{timestamp}] kernel: {interface}: link becomes ready",
        tags = {"network", "interface"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local interfaces = ctx.data.network.protocols.interfaces or {"eth0", "wlan0"}

        return {
            interface = ctx.random.choice(interfaces),
            mac_address = string.format("%02x:%02x:%02x:%02x:%02x:%02x",
                ctx.random.int(0, 255), ctx.random.int(0, 255), ctx.random.int(0, 255),
                ctx.random.int(0, 255), ctx.random.int(0, 255), ctx.random.int(0, 255))
        }
    end
}
