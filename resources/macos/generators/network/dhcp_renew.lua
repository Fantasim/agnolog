return {
    metadata = {
        name = "network.dhcp_renew",
        category = "NETWORK",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Network event",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Network event",
        tags = {},
        merge_groups = {}
    },
    generate = function(ctx, args)
        return {
            process = "configd",
            pid = ctx.random.int(50,200),
            level = "Default",
            subsystem = "com.apple.configd",
            category = "network"
        }
    end
}
