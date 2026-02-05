return {
    metadata = {
        name = "player.avatar_changed",
        category = "PLAYER",
        severity = "DEBUG",
        recurrence = "INFREQUENT",
        description = "Player changes their avatar",
        text_template = "[{timestamp}] AVATAR: {username} changed avatar to {avatar_type}",
        tags = {"player", "avatar", "customization"},
        merge_groups = {"player_events"}
    },
    generate = function(ctx, args)
        local avatar_types = {
            "uploaded_image",
            "default_avatar",
            "chess_piece_icon",
            "grandmaster_icon",
            "animal_avatar",
            "premium_avatar"
        }

        return {
            username = ctx.gen.player_name(),
            avatar_type = ctx.random.choice(avatar_types),
            is_premium = ctx.random.float(0, 1) < 0.3,
            file_size_kb = ctx.random.int(10, 500)
        }
    end
}
