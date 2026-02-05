-- Application Winlogon Notification Generator (Event ID 1001)
-- Generates Winlogon notification subscriber failure

return {
    metadata = {
        name = "application.winlogon_notification",
        category = "APPLICATION",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Winlogon notification subscriber failure",
        text_template = "Event Type: Warning\nEvent Source: Winlogon\nEvent Category: None\nEvent ID: 1001\nComputer: {computer}\nDescription:\nA notification package ({package}) failed to initialize and returned error code {error_code}.",
        tags = {"application", "winlogon", "notification", "warning"},
        merge_groups = {"winlogon_events"}
    },

    generate = function(ctx, args)
        local packages = {
            "sens",
            "sclgntfy",
            "Schedule",
            "wlnotify",
            "WgaLogon"
        }

        return {
            computer = ctx.gen.windows_computer(),
            package = ctx.random.choice(packages),
            error_code = ctx.random.choice({"0x80070005", "0xC0000022", "0x8007000E"})
        }
    end
}
