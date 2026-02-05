-- DNS Client Event 3020: DNS query sent
-- Tracks DNS resolution requests

return {
    metadata = {
        name = "dns_client.query_sent",
        category = "DNS_CLIENT",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "DNS query sent",
        text_template = "[{timestamp}] Event {event_id}: DNS query for {query_name}, type {query_type}",
        tags = {"dns", "network", "resolution"},
        merge_groups = {"dns_queries"}
    },

    generate = function(ctx, args)
        local domains = {
            "www.microsoft.com",
            "update.microsoft.com",
            "login.microsoftonline.com",
            "www.google.com",
            "api.github.com",
            "www.office.com",
            "outlook.office365.com",
            ctx.gen.windows_computer():lower() .. ".local"
        }

        local query_types = {
            {id = 1, name = "A"},
            {id = 28, name = "AAAA"},
            {id = 5, name = "CNAME"},
            {id = 15, name = "MX"}
        }

        local query_type = ctx.random.weighted_choice(query_types, {0.7, 0.15, 0.1, 0.05})

        return {
            event_id = 3020,
            provider_name = "Microsoft-Windows-DNS-Client",
            channel = "Microsoft-Windows-DNS-Client/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "None",
            keywords = "0x8000000000000000",

            query_name = ctx.random.choice(domains),
            query_type = query_type.name,
            query_type_id = query_type.id,
            dns_server = ctx.gen.ip_address(true),  -- Internal IP

            description = "DNS query sent"
        }
    end
}
