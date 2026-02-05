return {
    metadata = {
        name = "security.auth_success",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Authentication succeeded",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Authentication succeeded for user {username} ({method})",
        tags = {"security", "authentication", "success"},
        merge_groups = {"auth_events"}
    },
    generate = function(ctx, args)
        local auth_methods = ctx.data.security.auth_methods or {"password", "Touch ID"}
        local users = ctx.data.names.users or {"admin", "user"}
        return {
            process = ctx.random.choice({"securityd", "loginwindow", "authd", "sudo"}),
            pid = ctx.random.int(100, 65535),
            level = "Notice",
            subsystem = "com.apple.securityd",
            category = "authentication",
            username = ctx.random.choice(users),
            method = ctx.random.choice(auth_methods),
            session_id = ctx.gen.session_id()
        }
    end
}
