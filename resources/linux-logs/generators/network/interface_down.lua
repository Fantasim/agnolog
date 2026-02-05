-- Network Interface Down Generator
-- Generates network interface down log entries

return {
    metadata = {
        name = "network.interface_down",
        category = "NETWORK",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Network interface down",
        text_template = "[{timestamp}] kernel: {interface}: link is not ready",
        tags = {"network", "interface"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local interfaces = ctx.data.network.protocols.interfaces or {"eth0", "wlan0"}

        return {
            interface = ctx.random.choice(interfaces)
        }
    end
}
