return {
    metadata = {
        name = "application.sandbox_violation",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Sandbox violation",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Sandbox violation by {app_name}",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="sandboxd", pid=ctx.random.int(50,200), level="Error", subsystem="com.apple.sandbox", category="violation", app_name="Terminal"}
    end
}
