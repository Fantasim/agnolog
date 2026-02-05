-- DNS Query Generator
-- Generates DNS query log entries

return {
    metadata = {
        name = "network.dns_query",
        category = "NETWORK",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "DNS query",
        text_template = "[{timestamp}] dnsmasq[{pid}]: query[{type}] {domain} from {client_ip}",
        tags = {"network", "dns"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local record_types = ctx.data.network.connection_states.dns_record_types or {"A", "AAAA", "MX"}
        local domains = ctx.data.network.hostnames.domains or {"example.com"}
        local tlds = ctx.data.network.hostnames.tlds or {"com", "net", "org"}

        local subdomain = ctx.random.choice({"www", "mail", "api", "app", "db"})
        local domain = subdomain .. "." .. ctx.random.choice(domains)

        return {
            pid = ctx.random.int(500, 5000),
            type = ctx.random.choice(record_types),
            domain = domain,
            client_ip = ctx.gen.ip_address()
        }
    end
}
