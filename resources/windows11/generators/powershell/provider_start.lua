-- PowerShell Event 600: Provider Lifecycle
-- Tracks PowerShell provider operations

return {
    metadata = {
        name = "powershell.provider_start",
        category = "POWERSHELL",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "PowerShell provider started",
        text_template = "[{timestamp}] Event {event_id}: Provider '{provider_name}' is {state}",
        tags = {"powershell", "provider", "lifecycle"},
        merge_groups = {"powershell_providers"}
    },

    generate = function(ctx, args)
        local providers = {
            "Registry",
            "Alias",
            "Environment",
            "FileSystem",
            "Function",
            "Variable",
            "Certificate"
        }

        return {
            event_id = 600,
            provider_name = "PowerShell",
            channel = "Windows PowerShell",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "Provider Lifecycle",
            keywords = "0x0",

            provider = ctx.random.choice(providers),
            state = "Started",
            sequence_number = ctx.random.int(1, 1000),

            description = "Provider lifecycle event"
        }
    end
}
