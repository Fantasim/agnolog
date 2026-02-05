-- Security Event 4634: An account was logged off
-- Complements logon events for session tracking

return {
    metadata = {
        name = "security.logoff",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "An account was logged off",
        text_template = "[{timestamp}] Event {event_id}: {description} - User: {target_domain}\\{target_username}, Logon Type: {logon_type} ({logon_type_name})",
        tags = {"security", "authentication", "logoff", "audit"},
        merge_groups = {"security_logons"}
    },

    generate = function(ctx, args)
        -- Get logon types
        local logon_types = ctx.data.security.logon_types
        local logon_type = ctx.random.choice(logon_types)

        local computer_name = ctx.gen.windows_computer()
        local username = ctx.gen.windows_username()
        local domain = ctx.gen.windows_domain()
        local target_sid = ctx.gen.sid()

        -- Logon ID from original logon
        local target_logon_id = string.format("0x%x", ctx.random.int(100000, 999999999))

        return {
            event_id = 4634,
            provider_name = "Microsoft-Windows-Security-Auditing",
            channel = "Security",
            computer = computer_name,
            level = "Information",
            task_category = "Logoff",
            keywords = "0x8020000000000000",  -- Audit Success

            -- Target account that logged off
            target_sid = target_sid,
            target_username = username,
            target_domain = domain,
            target_logon_id = target_logon_id,

            -- Logon information
            logon_type = logon_type.id,
            logon_type_name = logon_type.name,

            description = "An account was logged off"
        }
    end
}
