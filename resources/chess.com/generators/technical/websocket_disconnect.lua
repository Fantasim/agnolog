return {
    metadata = {
        name = "technical.websocket_disconnect",
        category = "TECHNICAL",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "WebSocket connection closed",
        text_template = "[{timestamp}] WS_DISCONNECT: {username} disconnected - {reason}",
        tags = {"technical", "websocket", "disconnect"},
        merge_groups = {"connections"}
    },
    generate = function(ctx, args)
        local reasons = {
            "client_closed",
            "timeout",
            "server_shutdown",
            "protocol_error",
            "normal_closure",
            "connection_lost"
        }

        return {
            username = ctx.gen.player_name(),
            connection_id = ctx.gen.uuid(),
            reason = ctx.random.choice(reasons),
            duration_seconds = ctx.random.int(10, 7200),
            messages_sent = ctx.random.int(50, 5000),
            messages_received = ctx.random.int(50, 5000)
        }
    end
}
