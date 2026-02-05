-- Application Event 1002: Application Hang
-- Tracks application freeze/hang issues

return {
    metadata = {
        name = "application.app_hang",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Application hang",
        text_template = "[{timestamp}] Event {event_id}: {app_name} hung for more than {hang_duration} seconds",
        tags = {"application", "hang", "performance"},
        merge_groups = {"app_crashes"}
    },

    generate = function(ctx, args)
        local applications = {
            {name = "Explorer.EXE", path = "C:\\Windows\\Explorer.EXE"},
            {name = "chrome.exe", path = "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"},
            {name = "OUTLOOK.EXE", path = "C:\\Program Files\\Microsoft Office\\Office16\\OUTLOOK.EXE"},
            {name = "Teams.exe", path = "C:\\Program Files\\Microsoft Teams\\current\\Teams.exe"},
            {name = "Excel.EXE", path = "C:\\Program Files\\Microsoft Office\\Office16\\EXCEL.EXE"},
            {name = "firefox.exe", path = "C:\\Program Files\\Mozilla Firefox\\firefox.exe"}
        }

        local app = ctx.random.choice(applications)

        return {
            event_id = 1002,
            provider_name = "Application Hang",
            channel = "Application",
            computer = ctx.gen.windows_computer(),
            level = "Error",
            task_category = "Application Hang",
            keywords = "0x80000000000000",

            app_name = app.name,
            app_path = app.path,
            hang_duration = ctx.random.int(5, 120),
            hang_type = ctx.random.choice({"Program", "Window"}),
            process_id = string.format("0x%x", ctx.random.int(1000, 9999)),
            wait_chain = "Not available",

            description = "Program hung and was terminated"
        }
    end
}
