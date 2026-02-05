-- Network Workstation Error Generator (Event ID 3210)
-- Generates workstation service errors

return {
    metadata = {
        name = "network.workstation_error",
        category = "NETWORK",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Workstation service error",
        text_template = "Event Type: Warning\nEvent Source: Workstation\nEvent Category: None\nEvent ID: 3210\nComputer: {computer}\nDescription:\nFailed to connect to the \\\\{server}\\IPC$ share. Status code {status_code}.",
        tags = {"network", "workstation", "connection", "error"},
        merge_groups = {"network_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            server = ctx.gen.windows_computer(),
            status_code = ctx.random.choice({"0xC000006D", "0xC0000064", "0xC000005E"})
        }
    end
}
