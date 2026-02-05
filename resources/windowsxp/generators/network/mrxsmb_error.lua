-- Network MRxSmb Error Generator (Event ID 3034)
-- Generates SMB redirector errors

return {
    metadata = {
        name = "network.mrxsmb_error",
        category = "NETWORK",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "SMB redirector error",
        text_template = "Event Type: Warning\nEvent Source: MRxSmb\nEvent Category: None\nEvent ID: 3034\nComputer: {computer}\nDescription:\nThe redirector was unable to initialize security context or query context attributes.",
        tags = {"network", "mrxsmb", "smb", "error"},
        merge_groups = {"network_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer()
        }
    end
}
