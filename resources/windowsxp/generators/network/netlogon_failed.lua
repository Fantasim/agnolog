-- Network Netlogon Failed Generator (Event ID 5719)
-- Generates netlogon failed to locate domain controller events

return {
    metadata = {
        name = "network.netlogon_failed",
        category = "NETWORK",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Netlogon failed to locate domain controller",
        text_template = "Event Type: Error\nEvent Source: NETLOGON\nEvent Category: None\nEvent ID: 5719\nComputer: {computer}\nDescription:\nNo Windows NT Domain Controller is available for domain {domain}. The following error occurred:\n{error_message}",
        tags = {"network", "netlogon", "domain", "error"},
        merge_groups = {"network_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            domain = ctx.gen.windows_domain(),
            error_message = "There are currently no logon servers available to service the logon request."
        }
    end
}
