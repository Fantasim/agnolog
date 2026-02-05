return {
    metadata = {
        name = "application.launch",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Application launched",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Application {app_name} launched",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local apps = ctx.data.applications.system_apps or {"Safari"}
        return {
            process = "launchd",
            pid = 1,
            level = "Default",
            subsystem = "com.apple.launchd",
            category = "application",
            app_name = ctx.random.choice(apps)
        }
    end
}
