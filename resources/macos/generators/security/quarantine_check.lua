-- Security Quarantine Check Generator

return {
    metadata = {
        name = "security.quarantine_check",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Quarantine attribute check",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Quarantine check {result} for {file}",
        tags = {"security", "quarantine", "download"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local file_types = {".dmg", ".pkg", ".app", ".zip", ".tar.gz"}
        local result = ctx.random.choice({"passed", "flagged"})
        return {
            process = "launchservicesd",
            pid = ctx.random.int(50, 500),
            level = result == "passed" and "Default" or "Default",
            subsystem = "com.apple.LaunchServices",
            category = "quarantine",
            result = result,
            file = "~/Downloads/file" .. ctx.random.choice(file_types),
            source = ctx.random.choice({"Safari", "Mail", "curl"})
        }
    end
}
