-- Security Privilege Use Generator (Event ID 577)
-- Generates privileged service called events

return {
    metadata = {
        name = "security.privilege_use",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Privileged service called",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Privilege Use\nEvent ID: 577\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nPrivileged Service Called:\n  Server: {server}\n  Service: {service}\n  Primary User Name: {username}\n  Primary Domain: {domain}\n  Primary Logon ID: ({logon_id_high}, {logon_id_low})\n  Privileges: {privilege}",
        tags = {"security", "privilege", "service", "audit"},
        merge_groups = {"privilege_events"}
    },

    generate = function(ctx, args)
        local services = {
            "LsaRegisterLogonProcess",
            "SeTcbPrivilege",
            "SeDebugPrivilege",
            "SeBackupPrivilege",
            "SeRestorePrivilege"
        }

        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            server = "NT Local Security Authority / Authentication Service",
            service = ctx.random.choice(services),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999)),
            privilege = ctx.random.choice(services)
        }
    end
}
