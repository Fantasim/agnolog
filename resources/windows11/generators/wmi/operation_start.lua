-- WMI Event 11: WMI operation started
-- Tracks WMI activity

return {
    metadata = {
        name = "wmi.operation_start",
        category = "WMI",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "WMI operation started",
        text_template = "[{timestamp}] Event {event_id}: WMI operation started: {operation}",
        tags = {"wmi", "system", "management"},
        merge_groups = {"wmi_operations"}
    },

    generate = function(ctx, args)
        local operations = {
            "Start IWbemServices::ExecQuery - SELECT * FROM Win32_Process",
            "Start IWbemServices::ExecQuery - SELECT * FROM Win32_Service",
            "Start IWbemServices::ExecQuery - SELECT * FROM Win32_OperatingSystem",
            "Start IWbemServices::GetObject - Win32_ComputerSystem"
        }

        return {
            event_id = 11,
            provider_name = "Microsoft-Windows-WMI-Activity",
            channel = "Microsoft-Windows-WMI-Activity/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "None",
            keywords = "0x8000000000000000",

            operation = ctx.random.choice(operations),
            correlation_id = ctx.gen.guid(),
            operation_id = ctx.random.int(1000, 9999),

            description = "WMI activity started"
        }
    end
}
