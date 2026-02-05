return {
    metadata = {
        name = "application.exception",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Exception occurred",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Exception in {app_name}",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="ReportCrash", pid=ctx.random.int(100,500), level="Error", subsystem="com.apple.CrashReporter", category="exception", app_name="Messages"}
    end
}
