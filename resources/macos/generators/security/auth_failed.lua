return {
    metadata = {
        name = "security.auth_failed",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Authentication failed",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Authentication failed for user {username} ({method}) - {reason}",
        tags = {"security", "authentication", "failure"},
        merge_groups = {"auth_events"}
    },
    generate = function(ctx, args)
        local auth_methods = ctx.data.security.auth_methods or {"password", "Touch ID"}
        local users = ctx.data.names.users or {"admin", "user"}
        local reasons = {"Invalid password", "Account locked", "Too many attempts", "Biometric mismatch"}
        return {
            process = ctx.random.choice({"securityd", "loginwindow", "authd", "sudo"}),
            pid = ctx.random.int(100, 65535),
            level = "Error",
            subsystem = "com.apple.securityd",
            category = "authentication",
            username = ctx.random.choice(users),
            method = ctx.random.choice(auth_methods),
            reason = ctx.random.choice(reasons),
            attempt_count = ctx.random.int(1, 5),
            error_code = ctx.random.choice({-25291, -25300, -25293})
        }
    end
}
