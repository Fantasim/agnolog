-- SELinux Denial Generator
-- Generates SELinux denial log entries

return {
    metadata = {
        name = "security.selinux_denial",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "SELinux denial",
        text_template = "[{timestamp}] audit: type=AVC msg=audit({audit_id}): avc: denied { {permission} } for pid={pid} comm=\"{command}\" scontext={scontext} tcontext={tcontext} tclass={tclass}",
        tags = {"selinux", "security", "mac"},
        merge_groups = {"security_mac"}
    },

    generate = function(ctx, args)
        local permissions = ctx.data.security.security_modules.selinux_permissions or {"read", "write", "execute"}
        local contexts = ctx.data.security.security_modules.selinux_contexts or {"system_u:system_r:httpd_t"}
        local commands = {"httpd", "nginx", "mysqld", "sshd", "systemd"}

        return {
            audit_id = string.format("%d.%d:%d", ctx.random.int(1000000000, 9999999999), ctx.random.int(0, 999), ctx.random.int(1, 9999)),
            permission = ctx.random.choice(permissions),
            pid = ctx.random.int(100, 32768),
            command = ctx.random.choice(commands),
            scontext = ctx.random.choice(contexts),
            tcontext = ctx.random.choice(contexts),
            tclass = ctx.random.choice({"file", "dir", "sock_file", "tcp_socket"})
        }
    end
}
