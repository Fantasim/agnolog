return {
    metadata = {
        name = "player.logout",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Player logs out of Chess.com",
        text_template = "[{timestamp}] LOGOUT: {username} logged out after {session_duration} seconds",
        tags = {"player", "logout", "session"},
        merge_groups = {"sessions"}
    },
    generate = function(ctx, args)
        return {
            username = ctx.gen.player_name(),
            session_id = ctx.gen.session_id(),
            session_duration = ctx.random.int(300, 7200),
            games_played = ctx.random.int(0, 20),
            puzzles_solved = ctx.random.int(0, 15),
            logout_type = ctx.random.choice({"manual", "timeout", "auto"})
        }
    end
}
