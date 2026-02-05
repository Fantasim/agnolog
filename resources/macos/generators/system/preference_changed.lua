-- System Preference Changed Generator
-- Generates system preference change log entries

return {
    metadata = {
        name = "system.preference_changed",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "System preference changed",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Preference {domain}.{key} changed",
        tags = {"system", "preferences", "config"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local domains = {
            "com.apple.dock",
            "com.apple.finder",
            "com.apple.systempreferences",
            "com.apple.networkpreferences",
            "com.apple.security",
            "NSGlobalDomain"
        }

        local keys = {"AutoHide", "ShowHidden", "AppleShowAllFiles", "orientation", "tilesize"}

        return {
            process = "cfprefsd",
            pid = ctx.random.int(50, 500),
            level = "Debug",
            subsystem = "com.apple.cfprefsd",
            category = "preferences",
            domain = ctx.random.choice(domains),
            key = ctx.random.choice(keys),
            value_type = ctx.random.choice({"boolean", "string", "integer", "array"}),
            user = ctx.random.choice(ctx.data.names.users or {"admin"})
        }
    end
}
