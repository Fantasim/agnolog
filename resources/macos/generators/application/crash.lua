return {
    metadata = {
        name = "application.crash",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Application crashed",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Process {app_name}[{crashed_pid}] crashed: {crash_type}",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local apps = ctx.data.applications.system_apps or {"Safari"}
        local crash_types = ctx.data.applications.crash_types.mach_exceptions or {"EXC_BAD_ACCESS (SIGSEGV)"}
        return {
            process = "ReportCrash",
            pid = ctx.random.int(100, 500),
            level = "Fault",
            subsystem = "com.apple.CrashReporter",
            category = "crash",
            app_name = ctx.random.choice(apps),
            crashed_pid = ctx.random.int(1000, 65535),
            crash_type = ctx.random.choice(crash_types)
        }
    end
}
