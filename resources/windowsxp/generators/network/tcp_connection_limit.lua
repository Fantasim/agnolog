-- Network TCP Connection Limit Generator (Event ID 4226)
-- Generates TCP/IP connection limit reached events (XP SP2 specific)

return {
    metadata = {
        name = "network.tcp_connection_limit",
        category = "NETWORK",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "TCP/IP connection limit reached",
        text_template = "Event Type: Warning\nEvent Source: Tcpip\nEvent Category: None\nEvent ID: 4226\nComputer: {computer}\nDescription:\nTCP/IP has reached the security limit imposed on the number of concurrent TCP connect attempts.",
        tags = {"network", "tcp", "limit", "warning"},
        merge_groups = {"network_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer()
        }
    end
}
