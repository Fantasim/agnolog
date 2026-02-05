-- Fail2ban Unban Generator
-- Generates fail2ban IP unban log entries

return {
    metadata = {
        name = "security.fail2ban_unban",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Fail2ban unbanned IP",
        text_template = "[{timestamp}] fail2ban.actions[{pid}]: NOTICE [{jail}] Unban {ip}",
        tags = {"fail2ban", "security", "unban"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local jails = ctx.data.security.attack_patterns.fail2ban_jails or {"sshd", "nginx-http-auth"}

        return {
            pid = ctx.random.int(100, 32768),
            jail = ctx.random.choice(jails),
            ip = ctx.gen.ip_address(),
            ban_duration_seconds = ctx.random.int(600, 86400)
        }
    end
}
