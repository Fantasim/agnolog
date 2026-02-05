-- Sudo Security Violation Generator
-- Generates sudo security violation log entries

return {
    metadata = {
        name = "security.sudo_security_violation",
        category = "SECURITY",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Sudo security violation",
        text_template = "[{timestamp}] sudo[{pid}]: {user} : command not allowed ; COMMAND={command}",
        tags = {"sudo", "security", "violation"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local commands = {
            "/usr/bin/passwd root",
            "/usr/bin/rm -rf /",
            "/usr/bin/cat /etc/shadow",
            "/usr/sbin/visudo"
        }

        return {
            pid = ctx.random.int(100, 32768),
            user = ctx.gen.player_name(),
            command = ctx.random.choice(commands),
            tty = ctx.random.choice({"pts/0", "pts/1"})
        }
    end
}
