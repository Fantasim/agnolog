return {
    metadata = {
        name = "application.framework_load",
        category = "APPLICATION",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Framework loaded",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Loaded framework {framework}",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="dyld", pid=ctx.random.int(1000,65535), level="Debug", subsystem="com.apple.dyld", category="framework", framework="Foundation.framework"}
    end
}
