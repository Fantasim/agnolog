-- Windows Defender Event 1001: Antimalware scan finished
-- Tracks successful scan completion

return {
    metadata = {
        name = "defender.scan_completed",
        category = "DEFENDER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Windows Defender scan completed",
        text_template = "[{timestamp}] Event {event_id}: An antimalware scan finished. Scan Type: {scan_type_name}, Threats: {threat_count}",
        tags = {"defender", "scan", "antivirus", "complete"},
        merge_groups = {"defender_scans"}
    },

    generate = function(ctx, args)
        local scan_types = ctx.data.defender and ctx.data.defender.scan_types or {
            {id = 1, name = "Quick Scan"},
            {id = 2, name = "Full Scan"}
        }

        local scan_type = ctx.random.choice(scan_types)

        -- Most scans find no threats
        local threat_count = ctx.random.weighted_choice({0, 1, 2, 3}, {0.85, 0.1, 0.03, 0.02})

        return {
            event_id = 1001,
            provider_name = "Microsoft-Windows-Windows Defender",
            channel = "Microsoft-Windows-Windows Defender/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "None",
            keywords = "0x8000000000000000",

            scan_id = ctx.gen.guid(),
            scan_type_id = scan_type.id,
            scan_type_name = scan_type.name,
            threat_count = threat_count,
            scan_time = ctx.random.int(30, 7200),  -- seconds
            scanned_items = ctx.random.int(10000, 500000),

            description = "An antimalware scan finished"
        }
    end
}
