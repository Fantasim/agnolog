return {
    metadata = {
        name = "application.preference_write",
        category = "APPLICATION",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Preference written",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Wrote preference {key}",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="cfprefsd", pid=ctx.random.int(50,500), level="Debug", subsystem="com.apple.cfprefsd", category="preferences", key="ShowHidden"}
    end
}
