-- Application Crash Generator (Event ID 1000)
-- Generates application error/crash events

return {
    metadata = {
        name = "application.app_crash",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Application error (crash)",
        text_template = "Event Type: Error\nEvent Source: Application Error\nEvent Category: (100)\nEvent ID: 1000\nComputer: {computer}\nDescription:\nFaulting application {app_name}, version {app_version}, faulting module {fault_module}, version {module_version}, fault address {fault_address}.\n\nFor more information, see Help and Support Center at http://go.microsoft.com/fwlink/events.asp.",
        tags = {"application", "crash", "error"},
        merge_groups = {"app_crashes"}
    },

    generate = function(ctx, args)
        local apps_data = ctx.data.application and ctx.data.application.applications and ctx.data.application.applications.applications
        local apps = apps_data or {
            {name = "iexplore.exe", display_name = "Internet Explorer", version_range = {"6.0.2900.2180", "7.0.5730.13"}},
            {name = "explorer.exe", display_name = "Windows Explorer", version_range = {"6.0.2900.2180"}}
        }

        local app = ctx.random.choice(apps)
        local app_version = app.version_range and ctx.random.choice(app.version_range) or "6.0.2900.2180"

        local dlls_data = ctx.data.application and ctx.data.application.dlls
        local faulting_modules = (dlls_data and dlls_data.faulting_modules) or {"ntdll.dll", "kernel32.dll", "unknown"}

        return {
            computer = ctx.gen.windows_computer(),
            app_name = app.name,
            display_name = app.display_name or app.name,
            app_version = app_version,
            fault_module = ctx.random.choice(faulting_modules),
            module_version = string.format("%d.%d.%d.%d",
                ctx.random.int(5, 6),
                ctx.random.int(0, 1),
                ctx.random.int(2600, 3790),
                ctx.random.int(1000, 9999)),
            fault_address = string.format("0x%08x", ctx.random.int(0x00001000, 0x7fffffff)),
            exception_code = ctx.random.choice({"0xc0000005", "0xc0000409", "0xc000001d", "0xc0000094"})
        }
    end
}
