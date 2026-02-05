-- Firewall Accept Generator
-- Generates firewall packet accept log entries

return {
    metadata = {
        name = "network.firewall_accept",
        category = "NETWORK",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Firewall accepted packet",
        text_template = "[{timestamp}] kernel: iptables: IN={in_if} SRC={src_ip} DST={dst_ip} PROTO={proto} DPT={dst_port} ACCEPT",
        tags = {"network", "firewall"},
        merge_groups = {"firewall_events"}
    },

    generate = function(ctx, args)
        local interfaces = ctx.data.network.protocols.interfaces or {"eth0"}
        local protocols = ctx.data.network.protocols.protocols or {"TCP", "UDP"}
        local ports = ctx.data.network.protocols.common_ports or {}
        local port_list = {}
        for _, port in pairs(ports) do
            table.insert(port_list, port)
        end

        return {
            in_if = ctx.random.choice(interfaces),
            src_ip = ctx.gen.ip_address(),
            dst_ip = ctx.gen.ip_address(),
            proto = ctx.random.choice(protocols),
            dst_port = #port_list > 0 and ctx.random.choice(port_list) or 80
        }
    end
}
