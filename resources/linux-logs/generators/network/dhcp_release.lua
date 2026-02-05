-- DHCP Release Generator
-- Generates DHCP lease release log entries

return {
    metadata = {
        name = "network.dhcp_release",
        category = "NETWORK",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "DHCP lease released",
        text_template = "[{timestamp}] dhclient[{pid}]: DHCPRELEASE on {interface} to {server} port 67",
        tags = {"network", "dhcp"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local interfaces = ctx.data.network.protocols.interfaces or {"eth0"}

        return {
            pid = ctx.random.int(500, 32768),
            interface = ctx.random.choice(interfaces),
            server = ctx.gen.ip_address()
        }
    end
}
