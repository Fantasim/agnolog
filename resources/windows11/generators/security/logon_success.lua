-- Security Event 4624: An account was successfully logged on
-- Most common Windows security event

return {
    metadata = {
        name = "security.logon_success",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "An account was successfully logged on",
        text_template = "[{timestamp}] Event {event_id}: {description} - User: {target_domain}\\{target_username}, Logon Type: {logon_type} ({logon_type_name}), Workstation: {workstation_name}, Source IP: {ip_address}",
        tags = {"security", "authentication", "logon", "audit"},
        merge_groups = {"security_logons"}
    },

    generate = function(ctx, args)
        -- Get logon type data from YAML
        local logon_types = ctx.data.security.logon_types
        local logon_type = ctx.random.choice(logon_types)

        -- Get Windows-specific names using built-in generators
        local computer_name = ctx.gen.windows_computer()
        local username = ctx.gen.windows_username()
        local domain = ctx.gen.windows_domain()

        -- Generate SIDs
        local subject_sid = "S-1-5-18"  -- SYSTEM for most logons
        local target_sid = ctx.gen.sid()

        -- Generate session and logon IDs (hex format)
        local session_id = ctx.random.int(1, 1000000)
        local target_logon_id = string.format("0x%x", ctx.random.int(100000, 999999999))
        local subject_logon_id = "0x3e7"  -- SYSTEM logon ID

        -- IP address (blank for local, actual IP for network/RDP)
        local ip_address = "-"
        local workstation_name = computer_name

        if logon_type.id == 3 or logon_type.id == 10 then
            -- Network or RemoteInteractive logon
            ip_address = ctx.gen.ip_address()
            workstation_name = ctx.gen.windows_computer()
        end

        -- Authentication package based on logon type
        local auth_package = "Negotiate"
        local logon_process = "User32"

        if logon_type.id == 3 then
            auth_package = ctx.random.choice({"NTLM", "Kerberos"})
            logon_process = ctx.random.choice({"NtLmSsp", "Kerberos"})
        elseif logon_type.id == 10 then
            auth_package = ctx.random.choice({"Negotiate", "Kerberos"})
            logon_process = ctx.random.choice({"User32", "Advapi"})
        end

        return {
            event_id = 4624,
            provider_name = "Microsoft-Windows-Security-Auditing",
            channel = "Security",
            computer = computer_name,
            level = "Information",
            task_category = "Logon",
            keywords = "0x8020000000000000",  -- Audit Success

            -- Subject (the account that requested the logon)
            subject_sid = subject_sid,
            subject_username = computer_name .. "$",
            subject_domain = domain,
            subject_logon_id = subject_logon_id,

            -- Target (the account that was logged on)
            target_sid = target_sid,
            target_username = username,
            target_domain = domain,
            target_logon_id = target_logon_id,

            -- Logon information
            logon_type = logon_type.id,
            logon_type_name = logon_type.name,

            -- Network information
            workstation_name = workstation_name,
            ip_address = ip_address,
            ip_port = (ip_address ~= "-") and tostring(ctx.random.int(49152, 65535)) or "-",

            -- Authentication information
            authentication_package = auth_package,
            logon_process = logon_process,
            logon_guid = ctx.gen.guid(),

            -- Process information
            process_id = string.format("0x%x", ctx.random.int(1000, 9999)),
            process_name = ctx.random.choice({
                "C:\\Windows\\System32\\winlogon.exe",
                "C:\\Windows\\System32\\svchost.exe",
                "-"
            }),

            -- Additional fields
            session_id = session_id,
            description = "An account was successfully logged on"
        }
    end
}
