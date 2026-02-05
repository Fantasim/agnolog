-- DNS Client Event 1014: DNS query failed
-- Tracks DNS resolution failures

return {
    metadata = {
        name = "dns_client.query_failed",
        category = "DNS_CLIENT",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "DNS query failed",
        text_template = "[{timestamp}] Event {event_id}: Name resolution for {query_name} timed out after {timeout}ms",
        tags = {"dns", "network", "error"},
        merge_groups = {"dns_queries"}
    },

    generate = function(ctx, args)
        local domains = {
            "nonexistent.local",
            "invalid-domain-" .. ctx.random.int(1000, 9999) .. ".com",
            "timeout.example.com"
        }

        return {
            event_id = 1014,
            provider_name = "Microsoft-Windows-DNS-Client",
            channel = "System",
            computer = ctx.gen.windows_computer(),
            level = "Warning",
            task_category = "None",
            keywords = "0x80000000000000",

            query_name = ctx.random.choice(domains),
            timeout = ctx.random.choice({1000, 2000, 5000}),
            error_code = ctx.random.choice({"0x2746", "0x232B"}),  -- DNS_ERROR_TIMEOUT, DNS_ERROR_RECORD_TIMED_OUT

            description = "Name resolution timed out"
        }
    end
}
