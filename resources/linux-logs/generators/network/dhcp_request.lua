-- DHCP Request Generator
-- Generates DHCP request log entries

return {
    metadata = {
        name = "network.dhcp_request",
        category = "NETWORK",
        severity = "DEBUG",
        recurrence = "NORMAL",
        description = "DHCP request sent",
        text_template = "[{timestamp}] dhclient[{pid}]: DHCPREQUEST for {ip} on {interface} to {server} port 67",
        tags = {"network", "dhcp"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local interfaces = ctx.data.network.protocols.interfaces or {"eth0"}

        return {
            pid = ctx.random.int(500, 32768),
            ip = ctx.gen.ip_address(),
            interface = ctx.random.choice(interfaces),
            server = ctx.gen.ip_address(),
            xid = ctx.gen.hex_string(8)
        }
    end
}
