-- ICMP Unreachable Generator
-- Generates ICMP unreachable log entries

return {
    metadata = {
        name = "network.icmp_unreachable",
        category = "NETWORK",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "ICMP unreachable",
        text_template = "[{timestamp}] kernel: ICMP: {src_ip} destination unreachable (port {port})",
        tags = {"network", "icmp"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            src_ip = ctx.gen.ip_address(),
            dst_ip = ctx.gen.ip_address(),
            port = ctx.random.int(1, 65535)
        }
    end
}
