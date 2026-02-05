-- VPN Connect Generator
-- Generates VPN connection established log entries

return {
    metadata = {
        name = "network.vpn_connect",
        category = "NETWORK",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "VPN connection established",
        text_template = "[{timestamp}] openvpn[{pid}]: Initialization Sequence Completed to {server}",
        tags = {"network", "vpn"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768),
            server = ctx.gen.ip_address(),
            cipher = ctx.random.choice({"AES-256-GCM", "AES-256-CBC", "AES-128-GCM"}),
            user = ctx.gen.player_name()
        }
    end
}
