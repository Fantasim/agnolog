-- Windows Update Event 20: Installation failure
-- Tracks failed update installations

return {
    metadata = {
        name = "windows_update.update_failed",
        category = "WINDOWS_UPDATE",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Windows Update installation failed",
        text_template = "[{timestamp}] Event {event_id}: Installation Failure: {update_title}, Error: {error_code}",
        tags = {"windows_update", "installation", "failure", "error"},
        merge_groups = {"windows_updates"}
    },

    generate = function(ctx, args)
        local updates = {
            "2026-01 Cumulative Update for Windows 11 Version 22H2 for x64-based Systems (KB5012345)",
            "Update for Windows 11 Version 22H2 for x64-based Systems (KB5011234)",
            ".NET Framework 4.8.1 Update (KB5010987)"
        }

        local error_codes = {
            "0x80070643",  -- Fatal error during installation
            "0x800f0922",  -- Not enough disk space
            "0x80240017",  -- Update not applicable
            "0x8007000D",  -- Invalid data
            "0x80070020"   -- Process cannot access the file
        }

        return {
            event_id = 20,
            provider_name = "Microsoft-Windows-WindowsUpdateClient",
            channel = "System",
            computer = ctx.gen.windows_computer(),
            level = "Error",
            task_category = "None",
            keywords = "0x8000000000000000",

            update_title = ctx.random.choice(updates),
            update_guid = ctx.gen.guid(),
            error_code = ctx.random.choice(error_codes),

            description = "Installation Failure"
        }
    end
}
