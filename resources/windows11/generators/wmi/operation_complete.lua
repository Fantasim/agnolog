-- WMI Event 12: WMI operation completed
-- Tracks WMI completion

return {
    metadata = {
        name = "wmi.operation_complete",
        category = "WMI",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "WMI operation completed",
        text_template = "[{timestamp}] Event {event_id}: WMI operation completed successfully in {duration}ms",
        tags = {"wmi", "system", "management"},
        merge_groups = {"wmi_operations"}
    },

    generate = function(ctx, args)
        return {
            event_id = 12,
            provider_name = "Microsoft-Windows-WMI-Activity",
            channel = "Microsoft-Windows-WMI-Activity/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "None",
            keywords = "0x8000000000000000",

            correlation_id = ctx.gen.guid(),
            operation_id = ctx.random.int(1000, 9999),
            duration = ctx.random.int(10, 5000),
            result_code = "0x0",

            description = "WMI activity completed"
        }
    end
}
