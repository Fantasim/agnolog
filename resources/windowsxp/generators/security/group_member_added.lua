-- Security Group Member Added Generator (Event ID 632)
-- Generates member added to global group events

return {
    metadata = {
        name = "security.group_member_added",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "RARE",
        description = "Member added to global group",
        text_template = "Event Type: Success Audit\nEvent Source: Security\nEvent Category: Account Management\nEvent ID: 632\nUser: {domain}\\{admin_username}\nComputer: {computer}\nDescription:\nMember Added to Global Group:\n  Member Name: {member_username}\n  Member ID: {member_sid}\n  Target Account Name: {group_name}\n  Target Domain: {domain}\n  Target Account ID: {group_sid}\n  Caller User Name: {admin_username}\n  Caller Domain: {domain}\n  Caller Logon ID: ({logon_id_high}, {logon_id_low})\n  Privileges: -",
        tags = {"security", "group", "member", "audit"},
        merge_groups = {"account_management"}
    },

    generate = function(ctx, args)
        local group_names = {"Administrators", "Power Users", "Users", "Guests", "Remote Desktop Users", "Backup Operators"}

        return {
            admin_username = ctx.gen.windows_username(),
            member_username = ctx.gen.windows_username(),
            member_sid = ctx.gen.sid(),
            group_name = ctx.random.choice(group_names),
            group_sid = ctx.gen.sid(),
            domain = ctx.gen.windows_domain(),
            computer = ctx.gen.windows_computer(),
            logon_id_high = string.format("0x%X", ctx.random.int(0, 65535)),
            logon_id_low = string.format("0x%X", ctx.random.int(100000, 999999))
        }
    end
}
