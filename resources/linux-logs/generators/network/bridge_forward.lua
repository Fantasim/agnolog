-- Bridge Forward Generator
-- Generates bridge packet forwarding log entries

return {
    metadata = {
        name = "network.bridge_forward",
        category = "NETWORK",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Bridge forwarded packet",
        text_template = "[{timestamp}] kernel: br0: port {port} forwarded frame from {src_mac} to {dst_mac}",
        tags = {"network", "bridge"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local gen_mac = function()
            return string.format("%02x:%02x:%02x:%02x:%02x:%02x",
                ctx.random.int(0, 255), ctx.random.int(0, 255), ctx.random.int(0, 255),
                ctx.random.int(0, 255), ctx.random.int(0, 255), ctx.random.int(0, 255))
        end

        return {
            port = ctx.random.int(1, 8),
            src_mac = gen_mac(),
            dst_mac = gen_mac()
        }
    end
}
