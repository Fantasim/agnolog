-- Application Event 1000: Application Error
-- Common event for application crashes

return {
    metadata = {
        name = "application.app_error",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Application crash",
        text_template = "[{timestamp}] Event {event_id}: Faulting application {app_name}, version {app_version}, faulting module {fault_module}, exception code {exception_code}",
        tags = {"application", "crash", "error"},
        merge_groups = {"app_crashes"}
    },

    generate = function(ctx, args)
        local applications = {
            {name = "Explorer.EXE", path = "C:\\Windows\\Explorer.EXE", version = "10.0.19041.1"},
            {name = "chrome.exe", path = "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe", version = "96.0.4664.110"},
            {name = "OUTLOOK.EXE", path = "C:\\Program Files\\Microsoft Office\\Office16\\OUTLOOK.EXE", version = "16.0.5266.1000"},
            {name = "Teams.exe", path = "C:\\Program Files\\Microsoft Teams\\current\\Teams.exe", version = "1.4.00.26453"},
            {name = "java.exe", path = "C:\\Program Files\\Java\\jdk-11.0.12\\bin\\java.exe", version = "11.0.12.7"},
            {name = "notepad.exe", path = "C:\\Windows\\System32\\notepad.exe", version = "10.0.19041.1"},
            {name = "Excel.EXE", path = "C:\\Program Files\\Microsoft Office\\Office16\\EXCEL.EXE", version = "16.0.5266.1000"}
        }

        local app = ctx.random.choice(applications)

        -- Common exception codes
        local exception_codes = {
            "0xc0000005",  -- Access violation
            "0xc0000374",  -- Heap corruption
            "0x80000003",  -- Breakpoint
            "0xc000001d",  -- Illegal instruction
            "0xc0000409"   -- Stack buffer overrun
        }

        -- Common fault modules
        local fault_modules = {
            "ntdll.dll",
            "KERNELBASE.dll",
            "msvcrt.dll",
            app.name,
            "user32.dll",
            "kernel32.dll"
        }

        return {
            event_id = 1000,
            provider_name = "Application Error",
            channel = "Application",
            computer = ctx.gen.windows_computer(),
            level = "Error",
            task_category = "Application Crash",
            keywords = "0x80000000000000",

            app_name = app.name,
            app_version = app.version,
            app_timestamp = string.format("%x", ctx.random.int(0x50000000, 0x6fffffff)),
            app_path = app.path,

            fault_module = ctx.random.choice(fault_modules),
            fault_module_version = string.format("%d.%d.%d.%d",
                ctx.random.int(6, 10),
                ctx.random.int(0, 5),
                ctx.random.int(10000, 30000),
                ctx.random.int(1, 9999)
            ),
            fault_module_timestamp = string.format("%x", ctx.random.int(0x50000000, 0x6fffffff)),

            exception_code = ctx.random.choice(exception_codes),
            exception_offset = string.format("0x%08x", ctx.random.int(0x1000, 0xfffff)),

            process_id = string.format("0x%x", ctx.random.int(1000, 9999)),
            process_start_time = string.format("0x%016x", ctx.random.int(0x1000000000000, 0x1ffffffffffff)),

            description = "Application error"
        }
    end
}
