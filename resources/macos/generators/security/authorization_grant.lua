-- Security Authorization Grant Generator

return {
    metadata = {
        name = "security.authorization_grant",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Authorization granted",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Authorization granted for {right}",
        tags = {"security", "authorization", "privilege"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local rights = ctx.data.security.auth_rights or {"system.preferences"}
        return {
            process = "authd",
            pid = ctx.random.int(50, 500),
            level = "Notice",
            subsystem = "com.apple.security.authd",
            category = "authorization",
            right = ctx.random.choice(rights),
            user = ctx.random.choice(ctx.data.names.users or {"admin"})
        }
    end
}
