-- Application Hang Generator (Event ID 1002)
-- Generates application hang events

return {
    metadata = {
        name = "application.app_hang",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Application hang",
        text_template = "Event Type: Error\nEvent Source: Application Hang\nEvent Category: (101)\nEvent ID: 1002\nComputer: {computer}\nDescription:\nHanging application {app_name}, version {app_version}, hang module {hang_module}, version {module_version}, hang address {hang_address}.",
        tags = {"application", "hang", "error"},
        merge_groups = {"app_crashes"}
    },

    generate = function(ctx, args)
        local apps_data = ctx.data.application and ctx.data.application.applications and ctx.data.application.applications.applications
        local apps = apps_data or {
            {name = "iexplore.exe", version_range = {"6.0.2900.2180"}},
            {name = "WINWORD.EXE", version_range = {"11.0.5604.0"}}
        }

        local app = ctx.random.choice(apps)
        local app_version = app.version_range and ctx.random.choice(app.version_range) or "1.0.0.0"

        local hang_modules = {"hungapp", "unknown", "kernel32.dll", "user32.dll"}

        return {
            computer = ctx.gen.windows_computer(),
            app_name = app.name,
            app_version = app_version,
            hang_module = ctx.random.choice(hang_modules),
            module_version = "0.0.0.0",
            hang_address = string.format("0x%08x", ctx.random.int(0x00000000, 0x7fffffff))
        }
    end
}
