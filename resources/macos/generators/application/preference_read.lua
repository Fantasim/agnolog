return {
    metadata = {
        name = "application.preference_read",
        category = "APPLICATION",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Preference read",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Read preference {key}",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="cfprefsd", pid=ctx.random.int(50,500), level="Debug", subsystem="com.apple.cfprefsd", category="preferences", key="AutoHide"}
    end
}
