return {
    metadata = {
        name = "application.resume",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Application resumed",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Application {app_name} resumed",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="WindowServer", pid=ctx.random.int(100,500), level="Default", subsystem="com.apple.WindowServer", category="lifecycle", app_name="Mail"}
    end
}
