return {
    metadata = {
        name = "player.settings_changed",
        category = "PLAYER",
        severity = "DEBUG",
        recurrence = "NORMAL",
        description = "Player changes their settings",
        text_template = "[{timestamp}] SETTINGS: {username} changed {setting_category}",
        tags = {"player", "settings"},
        merge_groups = {"player_events"}
    },
    generate = function(ctx, args)
        local categories = {
            "board_appearance",
            "piece_set",
            "sound_effects",
            "notifications",
            "privacy",
            "game_behavior",
            "premoves",
            "highlights"
        }

        return {
            username = ctx.gen.player_name(),
            setting_category = ctx.random.choice(categories),
            settings_changed = ctx.random.int(1, 5)
        }
    end
}
