-- Sudo Failure Generator
-- Generates failed sudo attempt log entries

return {
    metadata = {
        name = "auth.sudo_failure",
        category = "AUTH",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Failed sudo attempt",
        text_template = "[{timestamp}] sudo: {user} : {attempts} incorrect password attempt{plural} ; TTY={tty} ; PWD={pwd} ; USER=root ; COMMAND={command}",
        tags = {"auth", "sudo", "failure"},
        merge_groups = {"auth_failures"}
    },

    generate = function(ctx, args)
        local commands = {
            "/usr/bin/systemctl restart sshd",
            "/usr/bin/apt install mysql-server",
            "/bin/cat /etc/shadow",
            "/usr/bin/passwd root"
        }

        local ttys = {"pts/0", "pts/1", "pts/2"}
        local attempts = ctx.random.int(1, 3)

        return {
            user = ctx.gen.username(),
            attempts = attempts,
            plural = attempts > 1 and "s" or "",
            tty = ctx.random.choice(ttys),
            pwd = "/home/" .. ctx.gen.username(),
            command = ctx.random.choice(commands)
        }
    end
}
