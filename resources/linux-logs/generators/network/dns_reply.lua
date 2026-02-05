-- DNS Reply Generator
-- Generates DNS reply log entries

return {
    metadata = {
        name = "network.dns_reply",
        category = "NETWORK",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "DNS reply",
        text_template = "[{timestamp}] dnsmasq[{pid}]: reply {domain} is {ip}",
        tags = {"network", "dns"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local domains = ctx.data.network.hostnames.domains or {"example.com"}
        local subdomain = ctx.random.choice({"www", "mail", "api"})
        local domain = subdomain .. "." .. ctx.random.choice(domains)

        return {
            pid = ctx.random.int(500, 5000),
            domain = domain,
            ip = ctx.gen.ip_address()
        }
    end
}
