-- Fail2ban Ban Generator
-- Generates fail2ban IP ban log entries

return {
    metadata = {
        name = "security.fail2ban_ban",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Fail2ban banned IP",
        text_template = "[{timestamp}] fail2ban.actions[{pid}]: NOTICE [{jail}] Ban {ip}",
        tags = {"fail2ban", "security", "ban"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local jails = ctx.data.security.attack_patterns.fail2ban_jails or {"sshd", "nginx-http-auth"}

        return {
            pid = ctx.random.int(100, 32768),
            jail = ctx.random.choice(jails),
            ip = ctx.gen.ip_address(),
            failures = ctx.random.int(3, 20)
        }
    end
}
