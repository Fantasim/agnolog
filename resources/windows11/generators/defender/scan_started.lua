-- Windows Defender Event 1000: Antimalware scan started
-- Tracks scan initiation

return {
    metadata = {
        name = "defender.scan_started",
        category = "DEFENDER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Windows Defender scan started",
        text_template = "[{timestamp}] Event {event_id}: An antimalware scan started. Scan Type: {scan_type_name}",
        tags = {"defender", "scan", "antivirus"},
        merge_groups = {"defender_scans"}
    },

    generate = function(ctx, args)
        local scan_types = ctx.data.defender and ctx.data.defender.scan_types or {
            {id = 1, name = "Quick Scan"},
            {id = 2, name = "Full Scan"}
        }

        local scan_type = ctx.random.choice(scan_types)

        return {
            event_id = 1000,
            provider_name = "Microsoft-Windows-Windows Defender",
            channel = "Microsoft-Windows-Windows Defender/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "None",
            keywords = "0x8000000000000000",

            scan_id = ctx.gen.guid(),
            scan_type_id = scan_type.id,
            scan_type_name = scan_type.name,
            scan_parameters = string.format("ScanType=%d;ScanTrigger=1", scan_type.id),

            description = "An antimalware scan started"
        }
    end
}
