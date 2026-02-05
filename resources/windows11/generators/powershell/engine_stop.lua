-- PowerShell Event 403: Engine state changed to Stopped
-- Tracks PowerShell engine shutdown

return {
    metadata = {
        name = "powershell.engine_stop",
        category = "POWERSHELL",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "PowerShell engine stopped",
        text_template = "[{timestamp}] Event {event_id}: Engine state is changed from {previous_state} to {new_state}",
        tags = {"powershell", "engine", "lifecycle"},
        merge_groups = {"powershell_lifecycle"}
    },

    generate = function(ctx, args)
        return {
            event_id = 403,
            provider_name = "PowerShell",
            channel = "Windows PowerShell",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "Engine Lifecycle",
            keywords = "0x0",

            previous_state = "Available",
            new_state = "Stopped",
            sequence_number = ctx.random.int(1, 1000),
            host_name = "ConsoleHost",
            host_version = "5.1." .. ctx.random.int(19000, 22000) .. ".1",
            host_id = ctx.gen.guid(),
            engine_version = "5.1." .. ctx.random.int(19000, 22000) .. ".1",
            runspace_id = ctx.gen.guid(),
            pipeline_id = ctx.random.int(1, 100),

            description = "Engine state is changed from Available to Stopped"
        }
    end
}
