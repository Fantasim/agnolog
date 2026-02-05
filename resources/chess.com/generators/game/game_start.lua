return {
    metadata = {
        name = "game.start",
        category = "GAME",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "A new chess game begins",
        text_template = "[{timestamp}] GAME_START: {white_player} vs {black_player} - {time_control} {variant}",
        tags = {"game", "start"},
        merge_groups = {"game_sessions"}
    },
    generate = function(ctx, args)
        local variants = ctx.data.game.variants
        local time_controls = ctx.data.game.time_controls

        -- Flatten all time controls into one list
        local all_time_controls = {}
        for _, category in pairs(time_controls) do
            for _, tc in ipairs(category) do
                table.insert(all_time_controls, tc)
            end
        end

        local variant = ctx.random.choice(variants)
        local time_control = ctx.random.choice(all_time_controls)

        local white_elo = ctx.random.int(800, 2800)
        local black_elo = ctx.random.int(white_elo - 100, white_elo + 100)

        return {
            game_id = ctx.gen.uuid(),
            white_player = ctx.gen.player_name(),
            black_player = ctx.gen.player_name(),
            white_elo = white_elo,
            black_elo = black_elo,
            time_control = time_control.name,
            time_category = time_control.category,
            variant = variant.name,
            rated = ctx.random.float(0, 1) < 0.85,
            tournament_game = ctx.random.float(0, 1) < 0.1
        }
    end
}
