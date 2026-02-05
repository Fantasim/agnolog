-- Sudo Success Generator
-- Generates successful sudo command log entries

return {
    metadata = {
        name = "auth.sudo_success",
        category = "AUTH",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Successful sudo command",
        text_template = "[{timestamp}] sudo: {user} : TTY={tty} ; PWD={pwd} ; USER=root ; COMMAND={command}",
        tags = {"auth", "sudo", "privilege"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local commands = {
            "/usr/bin/systemctl restart nginx",
            "/usr/bin/apt update",
            "/usr/bin/apt upgrade",
            "/usr/bin/systemctl status sshd",
            "/bin/cat /var/log/syslog",
            "/usr/bin/journalctl -xe",
            "/usr/bin/vim /etc/hosts",
            "/usr/sbin/service apache2 reload",
            "/usr/bin/docker ps",
            "/usr/bin/tail -f /var/log/auth.log"
        }

        local ttys = {"pts/0", "pts/1", "pts/2", "tty1", "tty2"}
        local pwds = {"/home/" .. ctx.gen.username(), "/root", "/var/log", "/etc", "/opt"}

        return {
            user = ctx.gen.username(),
            tty = ctx.random.choice(ttys),
            pwd = ctx.random.choice(pwds),
            command = ctx.random.choice(commands)
        }
    end
}
