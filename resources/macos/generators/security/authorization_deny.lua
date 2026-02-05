-- Security Authorization Deny Generator

return {
    metadata = {
        name = "security.authorization_deny",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Authorization denied",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Authorization denied for {right} - {reason}",
        tags = {"security", "authorization", "denied"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local rights = ctx.data.security.auth_rights or {"system.privilege.admin"}
        return {
            process = "authd",
            pid = ctx.random.int(50, 500),
            level = "Error",
            subsystem = "com.apple.security.authd",
            category = "authorization",
            right = ctx.random.choice(rights),
            user = ctx.random.choice(ctx.data.names.users or {"user"}),
            reason = ctx.random.choice({"Insufficient privileges", "User declined", "Authentication failed"})
        }
    end
}
