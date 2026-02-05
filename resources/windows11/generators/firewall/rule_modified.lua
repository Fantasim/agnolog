-- Firewall Event 2005: Firewall rule modified
-- Tracks firewall rule changes

return {
    metadata = {
        name = "firewall.rule_modified",
        category = "FIREWALL",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "A rule has been modified in the Windows Firewall exception list",
        text_template = "[{timestamp}] Event {event_id}: A rule has been modified in the Windows Firewall exception list. Rule Name: {rule_name}",
        tags = {"firewall", "configuration", "modification"},
        merge_groups = {"firewall_config"}
    },

    generate = function(ctx, args)
        local rule_names = {
            "Core Networking - DNS (UDP-Out)",
            "Remote Desktop - User Mode (TCP-In)",
            "File and Printer Sharing (SMB-In)",
            "CustomApp Allow Rule"
        }

        return {
            event_id = 2005,
            provider_name = "Microsoft-Windows-Windows Firewall With Advanced Security",
            channel = "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "Rule Modify",
            keywords = "0x8000000000000000",

            rule_id = ctx.gen.guid(),
            rule_name = ctx.random.choice(rule_names),
            origin = "Local",
            modified_by = ctx.gen.windows_domain() .. "\\" .. ctx.gen.windows_username(),

            description = "A rule has been modified in the Windows Firewall exception list"
        }
    end
}
