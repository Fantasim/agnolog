-- Network Srv Error Generator (Event ID 2000)
-- Generates server service errors

return {
    metadata = {
        name = "network.srv_error",
        category = "NETWORK",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Server service error",
        text_template = "Event Type: Error\nEvent Source: Srv\nEvent Category: None\nEvent ID: 2000\nComputer: {computer}\nDescription:\nThe server's configuration parameter \"{parameter}\" is greater than the maximum allowed value.",
        tags = {"network", "srv", "server", "error"},
        merge_groups = {"network_errors"}
    },

    generate = function(ctx, args)
        local parameters = {
            "MaxWorkItems",
            "MaxMpxCount",
            "InitWorkItems",
            "MaxRawWorkItems"
        }

        return {
            computer = ctx.gen.windows_computer(),
            parameter = ctx.random.choice(parameters)
        }
    end
}
