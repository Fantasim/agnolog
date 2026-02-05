return {
    metadata = {
        name = "matchmaking.match_found",
        category = "MATCHMAKING",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Two players matched for a game",
        text_template = "[{timestamp}] MATCH_FOUND: {white_player} ({white_elo}) vs {black_player} ({black_elo})",
        tags = {"matchmaking", "pairing"},
        merge_groups = {"matchmaking"}
    },
    generate = function(ctx, args)
        local time_controls = ctx.data.game.time_controls

        -- Flatten time controls
        local all_time_controls = {}
        for _, category in pairs(time_controls) do
            for _, tc in ipairs(category) do
                table.insert(all_time_controls, tc)
            end
        end

        local white_elo = ctx.random.int(800, 2800)
        local black_elo = ctx.random.int(white_elo - 100, white_elo + 100)

        return {
            match_id = ctx.gen.uuid(),
            white_player = ctx.gen.player_name(),
            black_player = ctx.gen.player_name(),
            white_elo = white_elo,
            black_elo = black_elo,
            elo_difference = math.abs(white_elo - black_elo),
            time_control = ctx.random.choice(all_time_controls).name,
            queue_wait_seconds = ctx.random.float(1, 30),
            variant = "standard"
        }
    end
}
