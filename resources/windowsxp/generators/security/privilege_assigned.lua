-- Security Privilege Assigned Generator (Event ID 576)
-- Generates special privileges assigned to new logon

return {
    metadata = {
        name = "security.privilege_assigned",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Special privileges assigned to new logon",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Privilege Use\nEvent ID: 576\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nSpecial privileges assigned to new logon:\n  User Name: {username}\n  Domain: {domain}\n  Logon ID: ({logon_id_high}, {logon_id_low})\n  Privileges: {privileges}",
        tags = {"security", "privilege", "audit"},
        merge_groups = {"privilege_events"}
    },

    generate = function(ctx, args)
        local privilege_sets = {
            "SeChangeNotifyPrivilege\n\t\t\tSeImpersonatePrivilege\n\t\t\tSeCreateGlobalPrivilege",
            "SeDebugPrivilege\n\t\t\tSeBackupPrivilege\n\t\t\tSeRestorePrivilege",
            "SeTcbPrivilege\n\t\t\tSeSecurityPrivilege\n\t\t\tSeTakeOwnershipPrivilege"
        }

        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999)),
            privileges = ctx.random.choice(privilege_sets)
        }
    end
}
