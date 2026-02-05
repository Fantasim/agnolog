return {
    metadata = {
        name = "application.memory_warning",
        category = "APPLICATION",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Memory warning",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Memory warning for {app_name}",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="kernel", pid=0, level="Default", subsystem="com.apple.kernel", category="memory", app_name="Photos", memory_mb=ctx.random.int(500,4000)}
    end
}
