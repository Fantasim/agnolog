return {
    metadata = {
        name = "application.plugin_load",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Plugin loaded",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Plugin {plugin_name} loaded",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {process="Safari", pid=ctx.random.int(1000,65535), level="Default", subsystem="com.apple.Safari", category="plugin", plugin_name="AdBlocker"}
    end
}
