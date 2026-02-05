return {
    metadata = {
        name = "security.sudo_attempt",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Sudo command attempted",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: User {username} attempted sudo: {command}",
        tags = {"security", "sudo", "privilege"},
        merge_groups = {"auth_events"}
    },
    generate = function(ctx, args)
        local users = ctx.data.names.users or {"admin", "user"}
        local commands = {"/bin/ls", "/usr/bin/vim", "/bin/cat", "/usr/sbin/diskutil", "/usr/bin/defaults"}
        return {
            process = "sudo",
            pid = ctx.random.int(1000, 65535),
            level = "Notice",
            subsystem = "com.apple.sudo",
            category = "privilege",
            username = ctx.random.choice(users),
            command = ctx.random.choice(commands),
            tty = ctx.random.choice({"/dev/ttys000", "/dev/ttys001", "/dev/console"})
        }
    end
}
