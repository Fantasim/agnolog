return {
    metadata = {
        name = "application.hang",
        category = "APPLICATION",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Application hang detected",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Application {app_name} not responding",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="WindowServer", pid=ctx.random.int(100,500), level="Default", subsystem="com.apple.WindowServer", category="hang", app_name="Safari"}
    end
}
