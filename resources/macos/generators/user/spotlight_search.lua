return {
    metadata = {
        name = "user.spotlight_search",
        category = "USER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "User event",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: User event",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {
            process = "loginwindow",
            pid = ctx.random.int(100,500),
            level = "Default",
            subsystem = "com.apple.loginwindow",
            category = "user"
        }
    end
}
