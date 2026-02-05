-- Certificate Renewed Generator
-- Generates SSL certificate renewal log entries

return {
    metadata = {
        name = "security.certificate_renewed",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "RARE",
        description = "SSL certificate renewed",
        text_template = "[{timestamp}] certbot[{pid}]: Successfully renewed certificate for {domain}",
        tags = {"certificate", "ssl", "tls"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local domains = ctx.data.network.hostnames.domains or {"example.com"}

        return {
            pid = ctx.random.int(100, 32768),
            domain = ctx.random.choice(domains),
            valid_days = ctx.random.int(60, 90)
        }
    end
}
