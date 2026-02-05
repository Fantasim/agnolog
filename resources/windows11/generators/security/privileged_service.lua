-- Security Event 4672: Special privileges assigned to new logon
-- Indicates privileged account logon

return {
    metadata = {
        name = "security.privileged_service",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Special privileges assigned to new logon",
        text_template = "[{timestamp}] Event {event_id}: {description} - User: {subject_domain}\\{subject_username}, Privileges: {privileges}",
        tags = {"security", "privileges", "audit"},
        merge_groups = {"privileged_operations"}
    },

    generate = function(ctx, args)
        local computer_name = ctx.gen.windows_computer()
        local username = ctx.gen.windows_username()
        local domain = ctx.gen.windows_domain()

        -- Special privileges that can be assigned
        local privilege_sets = {
            -- Administrator privileges
            {
                "SeSecurityPrivilege",
                "SeTakeOwnershipPrivilege",
                "SeLoadDriverPrivilege",
                "SeBackupPrivilege",
                "SeRestorePrivilege",
                "SeDebugPrivilege",
                "SeSystemEnvironmentPrivilege",
                "SeImpersonatePrivilege"
            },
            -- SYSTEM privileges
            {
                "SeAssignPrimaryTokenPrivilege",
                "SeTcbPrivilege",
                "SeSecurityPrivilege",
                "SeTakeOwnershipPrivilege",
                "SeLoadDriverPrivilege",
                "SeBackupPrivilege",
                "SeRestorePrivilege",
                "SeDebugPrivilege",
                "SeAuditPrivilege",
                "SeSystemEnvironmentPrivilege",
                "SeImpersonatePrivilege",
                "SeCreateGlobalPrivilege"
            },
            -- Service account privileges
            {
                "SeServiceLogonRight",
                "SeImpersonatePrivilege",
                "SeChangeNotifyPrivilege"
            }
        }

        local privileges_list = ctx.random.choice(privilege_sets)
        local privileges = table.concat(privileges_list, "\n\t\t\t")

        -- Check if system account
        local is_system = ctx.random.float(0, 1) < 0.3
        if is_system then
            username = "SYSTEM"
            domain = "NT AUTHORITY"
        end

        return {
            event_id = 4672,
            provider_name = "Microsoft-Windows-Security-Auditing",
            channel = "Security",
            computer = computer_name,
            level = "Information",
            task_category = "Special Logon",
            keywords = "0x8020000000000000",  -- Audit Success

            -- Subject (privileged account)
            subject_sid = is_system and "S-1-5-18" or ctx.gen.sid(),
            subject_username = username,
            subject_domain = domain,
            subject_logon_id = string.format("0x%x", ctx.random.int(100000, 999999999)),

            -- Privilege information
            privileges = privileges,
            privilege_count = #privileges_list,

            description = "Special privileges assigned to new logon"
        }
    end
}
