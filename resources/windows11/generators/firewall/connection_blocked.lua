-- Firewall Event 5157: Connection blocked
-- Tracks blocked network connections

return {
    metadata = {
        name = "firewall.connection_blocked",
        category = "FIREWALL",
        severity = "WARNING",
        recurrence = "FREQUENT",
        description = "Windows Firewall blocked a connection",
        text_template = "[{timestamp}] Event {event_id}: The Windows Filtering Platform blocked a connection. Application: {application}, Direction: {direction}, Source: {source_address}:{source_port}, Destination: {dest_address}:{dest_port}",
        tags = {"firewall", "network", "security", "blocked"},
        merge_groups = {"firewall_events"}
    },

    generate = function(ctx, args)
        local applications = {
            "\\device\\harddiskvolume3\\windows\\system32\\svchost.exe",
            "\\device\\harddiskvolume3\\program files\\google\\chrome\\application\\chrome.exe",
            "\\device\\harddiskvolume3\\windows\\explorer.exe",
            "System"
        }

        local directions = {"Inbound", "Outbound"}
        local direction = ctx.random.choice(directions)

        return {
            event_id = 5157,
            provider_name = "Microsoft-Windows-Windows Firewall With Advanced Security",
            channel = "Security",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "MPSSVC Rule-Level Policy Change",
            keywords = "0x8010000000000000",  -- Audit Failure

            application = ctx.random.choice(applications),
            direction = direction,
            source_address = ctx.gen.ip_address(),
            source_port = ctx.random.int(1024, 65535),
            dest_address = ctx.gen.ip_address(),
            dest_port = ctx.random.choice({80, 443, 445, 3389, 22, 21, 25, 53}),
            protocol = ctx.random.choice({6, 17}),  -- TCP or UDP
            filter_id = ctx.random.int(100000, 999999),

            description = "The Windows Filtering Platform has blocked a connection"
        }
    end
}
