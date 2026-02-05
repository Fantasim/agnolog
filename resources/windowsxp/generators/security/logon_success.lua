-- Security Logon Success Generator (Event ID 528)
-- Generates successful logon events

return {
    metadata = {
        name = "security.logon_success",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Successful logon",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Logon/Logoff\nEvent ID: 528\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nSuccessful Logon:\n  User Name: {username}\n  Domain: {domain}\n  Logon ID: ({logon_id_high}, {logon_id_low})\n  Logon Type: {logon_type}\n  Logon Process: {logon_process}\n  Authentication Package: {auth_package}\n  Workstation Name: {workstation}\n  Logon GUID: {logon_guid}\n  Caller Process ID: {caller_pid}\n  Source Network Address: {source_ip}\n  Source Port: {source_port}",
        tags = {"security", "logon", "audit", "success"},
        merge_groups = {"logon_events"}
    },

    generate = function(ctx, args)
        -- Choose logon type: 2=Interactive (most common), 3=Network, 10=RDP, 7=Unlock
        local logon_type_weights = {
            {2, 50},   -- Interactive (keyboard)
            {3, 30},   -- Network (SMB share access)
            {10, 15},  -- RemoteInteractive (RDP)
            {7, 5}     -- Unlock
        }

        local total_weight = 0
        for _, pair in ipairs(logon_type_weights) do
            total_weight = total_weight + pair[2]
        end

        local rand = ctx.random.float(0, total_weight)
        local cumulative = 0
        local logon_type = 2

        for _, pair in ipairs(logon_type_weights) do
            cumulative = cumulative + pair[2]
            if rand <= cumulative then
                logon_type = pair[1]
                break
            end
        end

        -- Set logon process and auth package based on type
        local logon_process = "User32"
        local auth_package = "Negotiate"

        if logon_type == 3 then
            logon_process = "NtLmSsp"
            auth_package = "NTLM"
        elseif logon_type == 10 then
            logon_process = "User32"
            auth_package = "Negotiate"
        elseif logon_type == 7 then
            logon_process = "User32"
            auth_package = "Negotiate"
        end

        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999)),
            logon_type = logon_type,
            logon_process = logon_process,
            auth_package = auth_package,
            workstation = ctx.gen.windows_computer(),
            logon_guid = ctx.gen.guid(),
            caller_pid = ctx.random.int(100, 9999),
            source_ip = ctx.gen.ip_address(true),
            source_port = ctx.random.int(1024, 65535)
        }
    end
}
