-- Application Event 1001: Windows Error Reporting
-- Tracks crash report submission

return {
    metadata = {
        name = "application.windows_error_reporting",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Windows Error Reporting",
        text_template = "[{timestamp}] Event {event_id}: Fault bucket {bucket_id}, type {fault_type}",
        tags = {"application", "error_reporting", "telemetry"},
        merge_groups = {"error_reporting"}
    },

    generate = function(ctx, args)
        local fault_types = {
            "0",
            "4",
            "5"
        }

        return {
            event_id = 1001,
            provider_name = "Windows Error Reporting",
            channel = "Application",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "None",
            keywords = "0x80000000000000",

            fault_bucket_id = ctx.random.int(100000000, 999999999),
            fault_bucket_type = ctx.random.choice(fault_types),
            event_name = ctx.random.choice({"APPCRASH", "APPHANG", "BEX", "BEX64"}),
            response_type = ctx.random.choice({"Not available", "Report sent"}),
            bucket_id = string.format("%d", ctx.random.int(100000000, 999999999)),

            description = "Fault bucket report"
        }
    end
}
