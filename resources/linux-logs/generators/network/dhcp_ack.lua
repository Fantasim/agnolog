-- DHCP ACK Generator
-- Generates DHCP lease acknowledgment log entries

return {
    metadata = {
        name = "network.dhcp_ack",
        category = "NETWORK",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "DHCP lease obtained",
        text_template = "[{timestamp}] dhclient[{pid}]: DHCPACK from {server} (xid=0x{xid})",
        tags = {"network", "dhcp"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(500, 32768),
            server = ctx.gen.ip_address(),
            xid = ctx.gen.hex_string(8),
            lease_time = ctx.random.int(3600, 86400)
        }
    end
}
