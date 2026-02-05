-- AppArmor Denial Generator
-- Generates AppArmor denial log entries

return {
    metadata = {
        name = "security.apparmor_denial",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "AppArmor denial",
        text_template = "[{timestamp}] audit: type=AVC apparmor=\"DENIED\" operation=\"{operation}\" profile=\"{profile}\" name=\"{path}\" pid={pid} comm=\"{command}\" requested_mask=\"{mask}\" denied_mask=\"{mask}\"",
        tags = {"apparmor", "security", "mac"},
        merge_groups = {"security_mac"}
    },

    generate = function(ctx, args)
        local profiles = ctx.data.security.security_modules.apparmor_profiles or {"/usr/sbin/nginx"}
        local operations = {"open", "file_mmap", "exec", "mknod", "unlink"}
        local masks = {"r", "w", "x", "rw", "rwx"}

        return {
            operation = ctx.random.choice(operations),
            profile = ctx.random.choice(profiles),
            path = "/etc/shadow",
            pid = ctx.random.int(100, 32768),
            command = "nginx",
            mask = ctx.random.choice(masks)
        }
    end
}
