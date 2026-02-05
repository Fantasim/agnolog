return {
    metadata = {
        name = "game.end",
        category = "GAME",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "A chess game ends",
        text_template = "[{timestamp}] GAME_END: {winner} defeated {loser} by {end_type} in {moves} moves",
        tags = {"game", "end", "result"},
        merge_groups = {"game_sessions"}
    },
    generate = function(ctx, args)
        local endgame_types = ctx.data.game.endgame_types

        -- Flatten all endgame types
        local all_end_types = {}
        for _, category in pairs(endgame_types) do
            for _, end_type in ipairs(category) do
                table.insert(all_end_types, end_type)
            end
        end

        local end_type = ctx.random.choice(all_end_types)
        local is_draw = not end_type.winner_determined

        local white_player = ctx.gen.player_name()
        local black_player = ctx.gen.player_name()

        local winner = "draw"
        local loser = "draw"

        if not is_draw then
            local white_wins = ctx.random.float(0, 1) < 0.5
            winner = white_wins and white_player or black_player
            loser = white_wins and black_player or white_player
        end

        local white_elo = ctx.random.int(800, 2800)
        local black_elo = ctx.random.int(white_elo - 100, white_elo + 100)

        local elo_change = ctx.random.int(5, 15)

        return {
            game_id = ctx.gen.uuid(),
            white_player = white_player,
            black_player = black_player,
            winner = winner,
            loser = loser,
            result = is_draw and "draw" or "decisive",
            end_type = end_type.type,
            moves = ctx.random.int(15, 80),
            duration_seconds = ctx.random.int(60, 3600),
            white_elo = white_elo,
            black_elo = black_elo,
            white_elo_change = is_draw and 0 or (winner == white_player and elo_change or -elo_change),
            black_elo_change = is_draw and 0 or (winner == black_player and elo_change or -elo_change),
            rated = ctx.random.float(0, 1) < 0.85
        }
    end
}
