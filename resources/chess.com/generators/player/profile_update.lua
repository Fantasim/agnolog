return {
    metadata = {
        name = "player.profile_update",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Player updates their profile",
        text_template = "[{timestamp}] PROFILE_UPDATE: {username} updated {field}",
        tags = {"player", "profile"},
        merge_groups = {"player_events"}
    },
    generate = function(ctx, args)
        local fields = {
            "bio",
            "avatar",
            "location",
            "birthday",
            "chess_title",
            "privacy_settings",
            "notification_preferences"
        }

        return {
            username = ctx.gen.player_name(),
            field = ctx.random.choice(fields),
            previous_value_length = ctx.random.int(0, 100),
            new_value_length = ctx.random.int(0, 100)
        }
    end
}
