-- Application Windows Error Reporting Generator (Event ID 1001)
-- Generates Windows Error Reporting events

return {
    metadata = {
        name = "application.windows_error_reporting",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Windows Error Reporting",
        text_template = "Event Type: Information\nEvent Source: Windows Error Reporting\nEvent Category: None\nEvent ID: 1001\nComputer: {computer}\nDescription:\nFault bucket {bucket_id}, type {fault_type}\nEvent Name: {event_name}\nResponse: {response}\nCab Id: {cab_id}\n\nProblem signature:\nP1: {app_name}\nP2: {app_version}\nP3: {timestamp}\nP4: {fault_module}\nP5: {module_version}\nP6: {module_timestamp}\nP7: {exception_code}\nP8: {fault_offset}",
        tags = {"application", "error_reporting", "wer"},
        merge_groups = {"app_crashes"}
    },

    generate = function(ctx, args)
        local apps_data = ctx.data.application and ctx.data.application.applications and ctx.data.application.applications.applications
        local apps = apps_data or {
            {name = "iexplore.exe", version_range = {"6.0.2900.2180"}},
            {name = "explorer.exe", version_range = {"6.0.2900.2180"}}
        }

        local app = ctx.random.choice(apps)
        local app_version = app.version_range and ctx.random.choice(app.version_range) or "1.0.0.0"

        return {
            computer = ctx.gen.windows_computer(),
            bucket_id = ctx.random.int(100000000, 999999999),
            fault_type = ctx.random.int(1, 5),
            event_name = "APPCRASH",
            response = "Not available",
            cab_id = "0",
            app_name = app.name,
            app_version = app_version,
            timestamp = string.format("%08x", ctx.random.int(0x40000000, 0x4fffffff)),
            fault_module = ctx.random.choice({"ntdll.dll", "kernel32.dll", "unknown"}),
            module_version = "5.1.2600.5512",
            module_timestamp = string.format("%08x", ctx.random.int(0x40000000, 0x4fffffff)),
            exception_code = ctx.random.choice({"c0000005", "c0000409"}),
            fault_offset = string.format("%08x", ctx.random.int(0x00001000, 0x000fffff))
        }
    end
}
