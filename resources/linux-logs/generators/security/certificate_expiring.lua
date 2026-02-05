-- Certificate Expiring Generator
-- Generates SSL certificate expiration warning log entries

return {
    metadata = {
        name = "security.certificate_expiring",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "RARE",
        description = "SSL certificate expiring",
        text_template = "[{timestamp}] certbot[{pid}]: Certificate {domain} expires in {days} days",
        tags = {"certificate", "ssl", "tls"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local domains = ctx.data.network.hostnames.domains or {"example.com"}

        return {
            pid = ctx.random.int(100, 32768),
            domain = ctx.random.choice(domains),
            days = ctx.random.int(1, 30)
        }
    end
}
