-- Windows Defender Event 1002: Antimalware scan was stopped before completion
-- Tracks scan interruptions

return {
    metadata = {
        name = "defender.scan_failed",
        category = "DEFENDER",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Windows Defender scan stopped before completion",
        text_template = "[{timestamp}] Event {event_id}: An antimalware scan was stopped before it finished. Scan Type: {scan_type_name}",
        tags = {"defender", "scan", "error"},
        merge_groups = {"defender_scans"}
    },

    generate = function(ctx, args)
        local scan_types = ctx.data.defender and ctx.data.defender.scan_types or {
            {id = 1, name = "Quick Scan"},
            {id = 2, name = "Full Scan"}
        }

        local scan_type = ctx.random.choice(scan_types)

        local stop_reasons = {
            "User stopped the scan",
            "System shutdown",
            "Resource constraint",
            "Scan timeout"
        }

        return {
            event_id = 1002,
            provider_name = "Microsoft-Windows-Windows Defender",
            channel = "Microsoft-Windows-Windows Defender/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Warning",
            task_category = "None",
            keywords = "0x8000000000000000",

            scan_id = ctx.gen.guid(),
            scan_type_id = scan_type.id,
            scan_type_name = scan_type.name,
            stop_reason = ctx.random.choice(stop_reasons),

            description = "An antimalware scan was stopped before it finished"
        }
    end
}
