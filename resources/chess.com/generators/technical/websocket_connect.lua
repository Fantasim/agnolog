return {
    metadata = {
        name = "technical.websocket_connect",
        category = "TECHNICAL",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "WebSocket connection established",
        text_template = "[{timestamp}] WS_CONNECT: {username} connected from {ip_address}",
        tags = {"technical", "websocket", "connection"},
        merge_groups = {"connections"}
    },
    generate = function(ctx, args)
        return {
            username = ctx.gen.player_name(),
            connection_id = ctx.gen.uuid(),
            ip_address = ctx.gen.ip_address(),
            protocol_version = ctx.random.choice({"13", "8"}),
            server_id = ctx.random.choice({"ws-server-01", "ws-server-02", "ws-server-03"}),
            user_agent = ctx.random.choice({"Chrome/120", "Firefox/115", "Safari/17", "Mobile App iOS", "Mobile App Android"})
        }
    end
}
