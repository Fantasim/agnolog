-- VPN Disconnect Generator
-- Generates VPN connection closed log entries

return {
    metadata = {
        name = "network.vpn_disconnect",
        category = "NETWORK",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "VPN connection closed",
        text_template = "[{timestamp}] openvpn[{pid}]: TCP/UDP: Closing socket",
        tags = {"network", "vpn"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768),
            duration_seconds = ctx.random.int(60, 28800),
            bytes_sent = ctx.random.int(1000000, 1000000000),
            bytes_received = ctx.random.int(1000000, 1000000000)
        }
    end
}
