-- Audit Event Generator
-- Generates Linux audit event log entries

return {
    metadata = {
        name = "security.audit_event",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Audit event logged",
        text_template = "[{timestamp}] audit[{pid}]: type={type} msg=audit({audit_id}): {message}",
        tags = {"audit", "security"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local audit_types = {"SYSCALL", "EXECVE", "PATH", "CWD", "USER_CMD", "CRED_DISP"}
        local messages = {
            "user pid=" .. ctx.random.int(100, 32768) .. " uid=" .. ctx.random.int(0, 60000),
            "syscall=" .. ctx.random.int(0, 300) .. " success=yes",
            "argc=" .. ctx.random.int(1, 10) .. " a0=" .. ctx.gen.hex_string(16)
        }

        return {
            pid = ctx.random.int(100, 32768),
            type = ctx.random.choice(audit_types),
            audit_id = string.format("%d.%d:%d", ctx.random.int(1000000000, 9999999999), ctx.random.int(0, 999), ctx.random.int(1, 9999)),
            message = ctx.random.choice(messages)
        }
    end
}
