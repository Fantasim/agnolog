-- Security Event 4740: A user account was locked out
-- Important security event for detecting brute force attacks

return {
    metadata = {
        name = "security.account_locked",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "RARE",
        description = "A user account was locked out",
        text_template = "[{timestamp}] Event {event_id}: {description} - User: {target_domain}\\{target_username}, Caller: {caller_computer}",
        tags = {"security", "account_management", "lockout", "audit"},
        merge_groups = {"account_management"}
    },

    generate = function(ctx, args)
        local computer_name = ctx.gen.windows_computer()
        local username = ctx.gen.windows_username()
        local domain = ctx.gen.windows_domain()
        local target_sid = ctx.gen.sid()

        -- Caller information (computer that caused lockout)
        local caller_computer = ctx.gen.windows_computer()

        -- Subject (usually SYSTEM or domain controller)
        local subject_username = ctx.random.choice({"SYSTEM", computer_name .. "$"})
        local subject_domain = ctx.random.choice({domain, "NT AUTHORITY"})

        return {
            event_id = 4740,
            provider_name = "Microsoft-Windows-Security-Auditing",
            channel = "Security",
            computer = computer_name,
            level = "Information",
            task_category = "User Account Management",
            keywords = "0x8020000000000000",  -- Audit Success

            -- Target account (that was locked)
            target_sid = target_sid,
            target_username = username,
            target_domain = domain,

            -- Subject (who detected the lockout)
            subject_sid = ctx.gen.sid(),
            subject_username = subject_username,
            subject_domain = subject_domain,
            subject_logon_id = string.format("0x%x", ctx.random.int(1000, 999999)),

            -- Caller information
            caller_computer = caller_computer,

            description = "A user account was locked out"
        }
    end
}
