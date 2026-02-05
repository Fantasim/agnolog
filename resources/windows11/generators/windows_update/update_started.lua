-- Windows Update Event 19: Installation started/ready
-- Tracks update installation

return {
    metadata = {
        name = "windows_update.update_started",
        category = "WINDOWS_UPDATE",
        severity = "INFO",
        recurrence = "RARE",
        description = "Windows Update installation started",
        text_template = "[{timestamp}] Event {event_id}: Installation Started: {update_title}",
        tags = {"windows_update", "installation", "system"},
        merge_groups = {"windows_updates"}
    },

    generate = function(ctx, args)
        local updates = {
            "2026-01 Cumulative Update for Windows 11 Version 22H2 for x64-based Systems (KB5012345)",
            "Security Intelligence Update for Microsoft Defender Antivirus - KB2267602",
            "Update for Windows 11 Version 22H2 for x64-based Systems (KB5011234)",
            ".NET Framework 4.8.1 Update (KB5010987)"
        }

        return {
            event_id = 19,
            provider_name = "Microsoft-Windows-WindowsUpdateClient",
            channel = "System",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "None",
            keywords = "0x8000000000000000",

            update_title = ctx.random.choice(updates),
            update_guid = ctx.gen.guid(),

            description = "Installation Started"
        }
    end
}
