-- Security Touch ID Auth Generator

return {
    metadata = {
        name = "security.touchid_auth",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Touch ID authentication",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Touch ID authentication {result} for user {username}",
        tags = {"security", "biometric", "touchid"},
        merge_groups = {"auth_events"}
    },
    generate = function(ctx, args)
        local users = ctx.data.names.users or {"admin"}
        local result = ctx.random.float(0, 1) < 0.92 and "succeeded" or "failed"
        return {
            process = "biometrickitd",
            pid = ctx.random.int(50, 500),
            level = result == "succeeded" and "Notice" or "Error",
            subsystem = "com.apple.BiometricKit",
            category = "touchid",
            result = result,
            username = ctx.random.choice(users),
            attempts = ctx.random.int(1, 3)
        }
    end
}
