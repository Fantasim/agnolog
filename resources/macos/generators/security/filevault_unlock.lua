-- Security FileVault Unlock Generator

return {
    metadata = {
        name = "security.filevault_unlock",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "RARE",
        description = "FileVault volume unlocked",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: FileVault volume unlocked for {volume}",
        tags = {"security", "filevault", "encryption"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {
            process = "kernel",
            pid = 0,
            level = "Notice",
            subsystem = "com.apple.kernel",
            category = "filevault",
            volume = "Macintosh HD",
            method = ctx.random.choice({"password", "recovery key", "institutional key"})
        }
    end
}
