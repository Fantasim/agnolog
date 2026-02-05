-- Security Logon Failed Generator (Event ID 529)
-- Generates failed logon attempts - unknown user or bad password

return {
    metadata = {
        name = "security.logon_failed",
        category = "SECURITY",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Logon failure - Unknown user name or bad password",
        text_template = "Event Type: Failure Audit\nEvent Source: Security\nEvent Category: Logon/Logoff\nEvent ID: 529\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nLogon Failure:\n  Reason: {reason}\n  User Name: {username}\n  Domain: {domain}\n  Logon Type: {logon_type}\n  Logon Process: {logon_process}\n  Authentication Package: {auth_package}\n  Workstation Name: {workstation}\n  Status code: {status_code}\n  Substatus code: {substatus_code}\n  Caller Process ID: {caller_pid}\n  Source Network Address: {source_ip}",
        tags = {"security", "logon", "audit", "failure"},
        merge_groups = {"logon_events"}
    },

    generate = function(ctx, args)
        -- Common failure reasons for Event 529
        local status_codes = {
            "0xC000006D",  -- Bad username or password
            "0xC000006A",  -- Correct username, wrong password
            "0xC0000064"   -- Username does not exist
        }

        local status_code = ctx.random.choice(status_codes)

        local reason_map = {
            ["0xC000006D"] = "Bad user name or password",
            ["0xC000006A"] = "User name is correct but password is wrong",
            ["0xC0000064"] = "User name does not exist"
        }

        local logon_type = ctx.random.choice({2, 3, 10})
        local logon_process = "User32"
        local auth_package = "Negotiate"

        if logon_type == 3 then
            logon_process = "NtLmSsp"
            auth_package = "NTLM"
        end

        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            logon_type = logon_type,
            logon_process = logon_process,
            auth_package = auth_package,
            workstation = ctx.gen.windows_computer(),
            status_code = status_code,
            substatus_code = status_code,
            reason = reason_map[status_code] or "Unknown error",
            caller_pid = ctx.random.int(100, 9999),
            source_ip = ctx.gen.ip_address(true)
        }
    end
}
