-- Port Scan Detected Generator
-- Generates port scan detection log entries

return {
    metadata = {
        name = "network.port_scan_detected",
        category = "NETWORK",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Port scan detected",
        text_template = "[{timestamp}] kernel: iptables: PORT SCAN detected from {src_ip} to ports {port_range}",
        tags = {"network", "security", "portscan"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local start_port = ctx.random.int(1, 60000)

        return {
            src_ip = ctx.gen.ip_address(),
            port_range = string.format("%d-%d", start_port, start_port + ctx.random.int(10, 100)),
            packets = ctx.random.int(50, 500)
        }
    end
}
