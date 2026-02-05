-- Security Process Create Generator (Event ID 592)
-- Generates process creation events

return {
    metadata = {
        name = "security.process_create",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "A new process has been created",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Process Tracking\nEvent ID: 592\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nA new process has been created:\n  New Process ID: {process_id}\n  Image File Name: {image_name}\n  Creator Process ID: {creator_pid}\n  User Name: {username}\n  Domain: {domain}\n  Logon ID: ({logon_id_high}, {logon_id_low})",
        tags = {"security", "process", "tracking", "audit"},
        merge_groups = {"process_tracking"}
    },

    generate = function(ctx, args)
        local processes = {
            "C:\\WINDOWS\\system32\\svchost.exe",
            "C:\\WINDOWS\\system32\\services.exe",
            "C:\\WINDOWS\\system32\\lsass.exe",
            "C:\\WINDOWS\\explorer.exe",
            "C:\\WINDOWS\\system32\\winlogon.exe",
            "C:\\WINDOWS\\system32\\spoolsv.exe",
            "C:\\Program Files\\Internet Explorer\\iexplore.exe",
            "C:\\WINDOWS\\system32\\notepad.exe",
            "C:\\WINDOWS\\system32\\cmd.exe"
        }

        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            process_id = ctx.random.int(100, 9999),
            image_name = ctx.random.choice(processes),
            creator_pid = ctx.random.int(100, 9999),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999))
        }
    end
}
