return {
    metadata = {
        name = "application.assertion",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Assertion failure",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Assertion failed in {app_name}",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="ReportCrash", pid=ctx.random.int(100,500), level="Error", subsystem="com.apple.CrashReporter", category="assertion", app_name="Safari"}
    end
}
