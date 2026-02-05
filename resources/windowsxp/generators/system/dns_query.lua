-- System DNS Query Generator
-- Generates DNS query resolution events

return {
    metadata = {
        name = "system.dns_query",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "DNS query resolved",
        text_template = "Event Type: Information\nEvent Source: Dnscache\nEvent Category: None\nEvent ID: 1014\nComputer: {computer}\nDescription:\nName resolution for the name {hostname} timed out after none of the configured DNS servers responded.",
        tags = {"system", "dns", "network", "query"},
        merge_groups = {"network_config"}
    },

    generate = function(ctx, args)
        local hostnames = {
            "www.microsoft.com",
            "windowsupdate.microsoft.com",
            "update.microsoft.com",
            "download.windowsupdate.com",
            "ntservicepack.microsoft.com"
        }

        return {
            computer = ctx.gen.windows_computer(),
            hostname = ctx.random.choice(hostnames)
        }
    end
}
