-- Network Redirector Timeout Generator (Event ID 3013)
-- Generates redirector timeout events

return {
    metadata = {
        name = "network.redirector_timeout",
        category = "NETWORK",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Redirector timeout",
        text_template = "Event Type: Warning\nEvent Source: Rdbss\nEvent Category: None\nEvent ID: 3013\nComputer: {computer}\nDescription:\nThe redirector has timed out a request to {remote_computer}.",
        tags = {"network", "redirector", "timeout", "smb"},
        merge_groups = {"network_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            remote_computer = ctx.gen.windows_computer()
        }
    end
}
