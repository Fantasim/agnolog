-- Windows Defender Event 5001: Real-time protection is disabled
-- Critical security event

return {
    metadata = {
        name = "defender.real_time_protection",
        category = "DEFENDER",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Real-time protection disabled",
        text_template = "[{timestamp}] Event {event_id}: Real-time protection is disabled",
        tags = {"defender", "protection", "security", "warning"},
        merge_groups = {"defender_config"}
    },

    generate = function(ctx, args)
        return {
            event_id = 5001,
            provider_name = "Microsoft-Windows-Windows Defender",
            channel = "Microsoft-Windows-Windows Defender/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Warning",
            task_category = "None",
            keywords = "0x8000000000000000",

            feature = "Real-time protection",
            reason = ctx.random.choice({
                "User disabled",
                "Group Policy",
                "Temporarily disabled for maintenance"
            }),

            description = "Real-time protection is disabled"
        }
    end
}
