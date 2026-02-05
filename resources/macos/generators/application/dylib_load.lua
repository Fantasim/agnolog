return {
    metadata = {
        name = "application.dylib_load",
        category = "APPLICATION",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Dynamic library loaded",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Loaded dylib {dylib}",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="dyld", pid=ctx.random.int(1000,65535), level="Debug", subsystem="com.apple.dyld", category="dylib", dylib="libSystem.dylib"}
    end
}
