-- Windows Defender Event 2000: Antimalware signature updated
-- Tracks definition updates

return {
    metadata = {
        name = "defender.definition_update",
        category = "DEFENDER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Windows Defender definitions updated",
        text_template = "[{timestamp}] Event {event_id}: The antimalware definitions updated successfully. Version: {signature_version}",
        tags = {"defender", "update", "definitions"},
        merge_groups = {"defender_updates"}
    },

    generate = function(ctx, args)
        -- Generate realistic signature version
        local version = string.format("1.%d.%d.0",
            ctx.random.int(380, 400),
            ctx.random.int(1000, 9999)
        )

        return {
            event_id = 2000,
            provider_name = "Microsoft-Windows-Windows Defender",
            channel = "Microsoft-Windows-Windows Defender/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "None",
            keywords = "0x8000000000000000",

            signature_version = version,
            engine_version = string.format("1.1.%d.0", ctx.random.int(19000, 22000)),
            signature_type = "AntiVirus",

            description = "The antimalware definitions updated successfully"
        }
    end
}
