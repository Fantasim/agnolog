return {
    metadata = {
        name = "application.terminate",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Application terminated",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Application {app_name} terminated",
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
            app_name = ctx.random.choice(apps),
            exit_code = ctx.random.int(0, 1)
        }
    end
}
