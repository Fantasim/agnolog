-- Network NetBT Error Generator (Event ID 4320)
-- Generates NetBIOS over TCP errors

return {
    metadata = {
        name = "network.netbt_error",
        category = "NETWORK",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "NetBIOS over TCP error",
        text_template = "Event Type: Warning\nEvent Source: NetBT\nEvent Category: None\nEvent ID: 4320\nComputer: {computer}\nDescription:\nAnother machine has sent a name release message to this machine probably because a duplicate name has been detected on the TCP network. The IP address of the node that sent the message is in the data. Use nbtstat -n in a command window to see which name is in the Conflict state.",
        tags = {"network", "netbt", "netbios", "duplicate"},
        merge_groups = {"network_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            conflicting_ip = ctx.gen.ip_address(true)
        }
    end
}
