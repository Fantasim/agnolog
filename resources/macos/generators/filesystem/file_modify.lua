return {
    metadata = {
        name = "filesystem.file_modify",
        category = "FILESYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Filesystem event",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Filesystem event",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {
            process = "fseventsd",
            pid = ctx.random.int(50,200),
            level = "Default",
            subsystem = "com.apple.fseventsd",
            category = "filesystem"
        }
    end
}
