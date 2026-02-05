-- ARP Request Generator
-- Generates ARP request log entries

return {
    metadata = {
        name = "network.arp_request",
        category = "NETWORK",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "ARP request",
        text_template = "[{timestamp}] kernel: arp: who-has {ip} tell {requester_ip}",
        tags = {"network", "arp"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            ip = ctx.gen.ip_address(),
            requester_ip = ctx.gen.ip_address()
        }
    end
}
