-- Application Userenv Error Generator (Event ID 1000)
-- Generates user profile error

return {
    metadata = {
        name = "application.userenv_error",
        category = "APPLICATION",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "User profile error",
        text_template = "Event Type: Warning\nEvent Source: Userenv\nEvent Category: None\nEvent ID: 1000\nComputer: {computer}\nDescription:\nWindows cannot access the file gpt.ini for GPO {gpo}. The file must exist at the location <{gpo_path}>. ({error_message}). Group Policy processing aborted.",
        tags = {"application", "userenv", "profile", "gpo"},
        merge_groups = {"userenv_errors"}
    },

    generate = function(ctx, args)
        local gpo_guid = ctx.gen.guid()

        return {
            computer = ctx.gen.windows_computer(),
            gpo = "CN=" .. gpo_guid .. ",CN=Policies,CN=System,DC=domain,DC=local",
            gpo_path = "\\\\domain.local\\sysvol\\domain.local\\Policies\\" .. gpo_guid .. "\\gpt.ini",
            error_message = "The system cannot find the path specified."
        }
    end
}
