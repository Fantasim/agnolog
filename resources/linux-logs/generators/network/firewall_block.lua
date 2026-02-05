-- Firewall Block Generator
-- Generates firewall packet block log entries

return {
    metadata = {
        name = "network.firewall_block",
        category = "NETWORK",
        severity = "WARNING",
        recurrence = "FREQUENT",
        description = "Firewall blocked packet",
        text_template = "[{timestamp}] kernel: iptables: IN={in_if} OUT={out_if} SRC={src_ip} DST={dst_ip} PROTO={proto} SPT={src_port} DPT={dst_port} BLOCKED",
        tags = {"network", "firewall", "security"},
        merge_groups = {"firewall_events"}
    },

    generate = function(ctx, args)
        local interfaces = ctx.data.network.protocols.interfaces or {"eth0"}
        local protocols = ctx.data.network.protocols.protocols or {"TCP", "UDP"}

        return {
            in_if = ctx.random.choice(interfaces),
            out_if = "",
            src_ip = ctx.gen.ip_address(),
            dst_ip = ctx.gen.ip_address(),
            proto = ctx.random.choice(protocols),
            src_port = ctx.random.int(1, 65535),
            dst_port = ctx.random.int(1, 65535)
        }
    end
}
