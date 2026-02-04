-- Player Logout Generator
-- Generates player logout log entries

return {
    metadata = {
        name = "player.logout",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Player logout event",
        text_template = "[{timestamp}] LOGOUT: {username} ({char_name}) reason: {reason} session: {session_duration}s",
        tags = {"auth", "player", "session"},
        merge_groups = {"sessions"}
    },

    generate = function(ctx, args)
        -- Get logout reasons from data
        local reasons = {"voluntary", "timeout", "kick", "server_shutdown", "connection_lost"}
        if ctx.data.constants and ctx.data.constants.server and ctx.data.constants.server.logout_reasons then
            reasons = ctx.data.constants.server.logout_reasons
        end

        -- Session duration bounds
        local min_duration = 60
        local max_duration = 28800
        if ctx.data.constants and ctx.data.constants.server and ctx.data.constants.server.session then
            min_duration = ctx.data.constants.server.session.min_duration_seconds or 60
            max_duration = ctx.data.constants.server.session.max_duration_seconds or 28800
        end

        local username = args.username or ctx.gen.player_name()
        local char_name = args.char_name or ctx.gen.character_name()

        return {
            username = username,
            char_name = char_name,
            reason = ctx.random.choice(reasons),
            session_id = args.session_id or ctx.gen.session_id(),
            session_duration = ctx.random.int(min_duration, max_duration),
            xp_gained = ctx.random.int(0, 50000),
            gold_gained = ctx.random.int(0, 10000),
            gold_spent = ctx.random.int(0, 5000)
        }
    end
}
