return {
    metadata = {
        name = "application.suspend",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Application suspended",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Application {app_name} suspended",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="WindowServer", pid=ctx.random.int(100,500), level="Default", subsystem="com.apple.WindowServer", category="lifecycle", app_name="Calendar"}
    end
}
