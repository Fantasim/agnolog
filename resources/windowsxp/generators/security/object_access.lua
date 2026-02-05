-- Security Object Access Generator (Event ID 560)
-- Generates object open access events

return {
    metadata = {
        name = "security.object_access",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Object open",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Object Access\nEvent ID: 560\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nObject Open:\n  Object Server: {object_server}\n  Object Type: {object_type}\n  Object Name: {object_name}\n  Handle ID: {handle_id}\n  Operation ID: {operation_id}\n  Process ID: {process_id}\n  Primary User Name: {username}\n  Primary Domain: {domain}\n  Primary Logon ID: ({logon_id_high}, {logon_id_low})\n  Accesses: {accesses}",
        tags = {"security", "object", "access", "audit"},
        merge_groups = {"object_access"}
    },

    generate = function(ctx, args)
        local object_types = {"File", "Key", "Token", "Process", "Thread"}
        local object_names = {
            "C:\\WINDOWS\\system32\\config\\SAM",
            "C:\\Documents and Settings\\{username}\\NTUSER.DAT",
            "HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion",
            "C:\\WINDOWS\\system32\\lsass.exe",
            "\\Device\\HarddiskVolume1\\WINDOWS\\system32\\notepad.exe"
        }
        local accesses = {
            "READ_CONTROL",
            "WriteData (or AddFile)",
            "AppendData (or AddSubdirectory or CreatePipeInstance)",
            "ReadData (or ListDirectory)",
            "DELETE"
        }

        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            object_server = "Security",
            object_type = ctx.random.choice(object_types),
            object_name = ctx.random.choice(object_names),
            handle_id = string.format("0x%X", ctx.random.int(100, 9999)),
            operation_id = string.format("{0x%X,0x%X}", ctx.random.int(1000, 9999), ctx.random.int(1000, 9999)),
            process_id = ctx.random.int(100, 9999),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999)),
            accesses = ctx.random.choice(accesses)
        }
    end
}
