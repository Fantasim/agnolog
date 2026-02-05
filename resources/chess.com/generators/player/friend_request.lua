return {
    metadata = {
        name = "player.friend_request",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player sends friend request",
        text_template = "[{timestamp}] FRIEND_REQUEST: {sender} sent request to {recipient}",
        tags = {"player", "friend", "social"},
        merge_groups = {"player_events"}
    },
    generate = function(ctx, args)
        return {
            sender = ctx.gen.player_name(),
            recipient = ctx.gen.player_name(),
            sender_elo = ctx.random.int(800, 2800),
            recipient_elo = ctx.random.int(800, 2800),
            message_included = ctx.random.float(0, 1) < 0.3,
            met_in_game = ctx.random.float(0, 1) < 0.7
        }
    end
}
