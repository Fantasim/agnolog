return {
    metadata = {
        name = "player.friend_accepted",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player accepts friend request",
        text_template = "[{timestamp}] FRIEND_ACCEPTED: {accepter} accepted request from {requester}",
        tags = {"player", "friend", "social"},
        merge_groups = {"player_events"}
    },
    generate = function(ctx, args)
        return {
            accepter = ctx.gen.player_name(),
            requester = ctx.gen.player_name(),
            response_time_hours = ctx.random.int(1, 168),
            mutual_friends = ctx.random.int(0, 50)
        }
    end
}
