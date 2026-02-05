-- Security Event 4625: An account failed to log on
-- Critical for security monitoring and brute force detection

return {
    metadata = {
        name = "security.logon_failure",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "An account failed to log on",
        text_template = "[{timestamp}] Event {event_id}: {description} - User: {target_domain}\\{target_username}, Failure Reason: {failure_reason}, Status: {status}, Logon Type: {logon_type}, Source IP: {ip_address}",
        tags = {"security", "authentication", "failure", "audit"},
        merge_groups = {"security_logons"}
    },

    generate = function(ctx, args)
        -- Get logon types
        local logon_types = ctx.data.security.logon_types
        local logon_type = ctx.random.choice(logon_types)

        local computer_name = ctx.gen.windows_computer()
        local username = ctx.gen.windows_username()
        local domain = ctx.gen.windows_domain()

        -- Failure reasons with NTSTATUS codes
        local failure_reasons = {
            {status = "0xC000006D", sub_status = "0xC0000064", reason = "Bad username"},
            {status = "0xC000006D", sub_status = "0xC000006A", reason = "Bad password"},
            {status = "0xC0000234", sub_status = "0x0", reason = "Account locked out"},
            {status = "0xC0000072", sub_status = "0x0", reason = "Account disabled"},
            {status = "0xC000006F", sub_status = "0x0", reason = "Logon outside authorized hours"},
            {status = "0xC0000070", sub_status = "0x0", reason = "Workstation restriction"},
            {status = "0xC0000071", sub_status = "0x0", reason = "Password expired"},
            {status = "0xC0000193", sub_status = "0x0", reason = "Account expiration"},
            {status = "0xC0000133", sub_status = "0x0", reason = "Time synchronization error"},
            {status = "0xC000015B", sub_status = "0x0", reason = "User not granted logon type"}
        }

        local failure = ctx.random.choice(failure_reasons)

        -- IP address (more likely to have one for failed logons)
        local ip_address = ctx.gen.ip_address()
        if ctx.random.float(0, 1) < 0.2 then
            ip_address = "-"
        end

        -- Workstation name
        local workstation_name = ctx.gen.windows_computer()

        return {
            event_id = 4625,
            provider_name = "Microsoft-Windows-Security-Auditing",
            channel = "Security",
            computer = computer_name,
            level = "Information",
            task_category = "Logon",
            keywords = "0x8010000000000000",  -- Audit Failure

            -- Subject (always empty for failed logons)
            subject_sid = "S-1-0-0",
            subject_username = "-",
            subject_domain = "-",
            subject_logon_id = "0x0",

            -- Target
            target_sid = "S-1-0-0",
            target_username = username,
            target_domain = domain,

            -- Logon information
            logon_type = logon_type.id,
            logon_type_name = logon_type.name,

            -- Failure information
            status = failure.status,
            sub_status = failure.sub_status,
            failure_reason = failure.reason,

            -- Network information
            workstation_name = workstation_name,
            ip_address = ip_address,
            ip_port = (ip_address ~= "-") and tostring(ctx.random.int(49152, 65535)) or "-",

            -- Authentication information
            authentication_package = ctx.random.choice({"-", "NTLM", "Negotiate"}),
            logon_process = ctx.random.choice({"NtLmSsp", "User32", "Advapi"}),
            logon_guid = ctx.gen.guid(),

            -- Process information
            process_id = "0x0",
            process_name = "-",

            description = "An account failed to log on"
        }
    end
}
