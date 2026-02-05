return {
    metadata = {
        name = "security.sudo_success",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Sudo command succeeded",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: User {username} executed sudo successfully",
        tags = {"security", "sudo", "privilege"},
        merge_groups = {"auth_events"}
    },
    generate = function(ctx, args)
        local users = ctx.data.names.users or {"admin", "user"}
        return {
            process = "sudo",
            pid = ctx.random.int(1000, 65535),
            level = "Notice",
            subsystem = "com.apple.sudo",
            category = "privilege",
            username = ctx.random.choice(users),
            command_pid = ctx.random.int(1000, 65535)
        }
    end
}
