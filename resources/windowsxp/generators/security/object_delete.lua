-- Security Object Delete Generator (Event ID 564)
-- Generates object deleted events

return {
    metadata = {
        name = "security.object_delete",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Object deleted",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Object Access\nEvent ID: 564\nUser: {domain}\\{username}\nComputer: {computer}\nDescription:\nObject Deleted:\n  Object Server: {object_server}\n  Object Type: {object_type}\n  Object Name: {object_name}\n  Process ID: {process_id}\n  Primary User Name: {username}\n  Primary Domain: {domain}\n  Primary Logon ID: ({logon_id_high}, {logon_id_low})",
        tags = {"security", "object", "delete", "audit"},
        merge_groups = {"object_access"}
    },

    generate = function(ctx, args)
        local object_types = {"File", "Key"}
        local object_names = {
            "C:\\WINDOWS\\Temp\\tmp{random}.tmp",
            "C:\\Documents and Settings\\{username}\\Local Settings\\Temp\\~DF{random}.tmp",
            "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\{random}"
        }

        local random_hex = string.format("%04X", ctx.random.int(0, 65535))
        local object_name = ctx.random.choice(object_names):gsub("{random}", random_hex)

        return {
            username = ctx.gen.windows_username(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            object_server = "Security",
            object_type = ctx.random.choice(object_types),
            object_name = object_name,
            process_id = ctx.random.int(100, 9999),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999))
        }
    end
}
