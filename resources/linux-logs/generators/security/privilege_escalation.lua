-- Privilege Escalation Generator
-- Generates privilege escalation detection log entries

return {
    metadata = {
        name = "security.privilege_escalation",
        category = "SECURITY",
        severity = "CRITICAL",
        recurrence = "RARE",
        description = "Privilege escalation detected",
        text_template = "[{timestamp}] kernel: security: process {pid} ({process}) attempted privileged operation without capability {capability}",
        tags = {"security", "privilege", "escalation"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local capabilities = ctx.data.security.security_modules.capabilities or {
            "CAP_SYS_ADMIN",
            "CAP_NET_ADMIN",
            "CAP_SYS_MODULE"
        }

        local processes = {"bash", "python", "perl", "ruby", "php"}

        return {
            pid = ctx.random.int(100, 32768),
            process = ctx.random.choice(processes),
            capability = ctx.random.choice(capabilities),
            uid = ctx.random.int(1000, 60000)
        }
    end
}
