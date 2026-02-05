-- System Browser Election Generator (Event ID 8003)
-- Generates master browser election events

return {
    metadata = {
        name = "system.browser_election",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Master browser election",
        text_template = "Event Type: Information\nEvent Source: BROWSER\nEvent Category: None\nEvent ID: 8003\nComputer: {computer}\nDescription:\nThe master browser has received a server announcement from the computer {announced_computer} that believes that it is the master browser for the domain on transport {transport}.\nThe master browser is stopping or an election is being forced.",
        tags = {"system", "browser", "election", "network"},
        merge_groups = {"browser_events"}
    },

    generate = function(ctx, args)
        local transports = {
            "NetBT_Tcpip_{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}",
            "NetbiosSmb"
        }

        return {
            computer = ctx.gen.windows_computer(),
            announced_computer = ctx.gen.windows_computer(),
            domain = ctx.gen.windows_domain(),
            transport = ctx.random.choice(transports)
        }
    end
}
