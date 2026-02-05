-- Firewall Event 2004: Firewall rule added
-- Tracks firewall configuration changes

return {
    metadata = {
        name = "firewall.rule_added",
        category = "FIREWALL",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "A rule has been added to the Windows Firewall exception list",
        text_template = "[{timestamp}] Event {event_id}: A rule has been added to the Windows Firewall exception list. Rule Name: {rule_name}, Origin: {origin}",
        tags = {"firewall", "configuration", "security"},
        merge_groups = {"firewall_config"}
    },

    generate = function(ctx, args)
        local rule_names = {
            "Core Networking - DNS (UDP-Out)",
            "Core Networking - HTTP (TCP-Out)",
            "Remote Desktop - User Mode (TCP-In)",
            "File and Printer Sharing (SMB-In)",
            "Windows Remote Management (HTTP-In)",
            "CustomApp Allow Rule"
        }

        return {
            event_id = 2004,
            provider_name = "Microsoft-Windows-Windows Firewall With Advanced Security",
            channel = "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "Rule Add",
            keywords = "0x8000000000000000",

            rule_id = ctx.gen.guid(),
            rule_name = ctx.random.choice(rule_names),
            origin = ctx.random.choice({"Local", "Group Policy"}),
            active = "Yes",
            direction = ctx.random.choice({"In", "Out"}),
            profiles = "Domain,Private,Public",

            description = "A rule has been added to the Windows Firewall exception list"
        }
    end
}
