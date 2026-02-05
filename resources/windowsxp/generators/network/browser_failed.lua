-- Network Browser Failed Generator (Event ID 8032)
-- Generates browser failed to retrieve backup list

return {
    metadata = {
        name = "network.browser_failed",
        category = "NETWORK",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Browser failed to retrieve backup list",
        text_template = "Event Type: Error\nEvent Source: BROWSER\nEvent Category: None\nEvent ID: 8032\nComputer: {computer}\nDescription:\nThe browser service has failed to retrieve the backup list too many times on transport {transport}. The backup browser is stopping.",
        tags = {"network", "browser", "backup", "error"},
        merge_groups = {"browser_events"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            transport = "NetBT_Tcpip_{" .. string.upper(ctx.gen.uuid()) .. "}"
        }
    end
}
