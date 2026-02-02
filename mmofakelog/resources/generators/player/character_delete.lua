-- Player Character Delete Generator

return {
    metadata = {
        name = "player.character_delete",
        category = "PLAYER",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Character deletion",
        text_template = "[{timestamp}] CHAR_DELETE: {username} deleted {char_name} (level {level})",
        tags = {"player", "character"}
    },

    generate = function(ctx, args)
        local max_level = 60

        return {
            username = args.username or ctx.gen.player_name(),
            char_name = ctx.gen.character_name(),
            level = ctx.random.int(1, max_level),
            playtime_hours = ctx.random.int(1, 5000)
        }
    end
}
