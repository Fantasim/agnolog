return {
    metadata = {
        name = "game.insufficient_material",
        category = "GAME",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Game ends due to insufficient material",
        text_template = "[{timestamp}] INSUFFICIENT_MATERIAL: {white_player} vs {black_player} - draw",
        tags = {"game", "draw", "material"},
        merge_groups = {"game_events"}
    },
    generate = function(ctx, args)
        local material_combos = {
            "K vs K",
            "K+N vs K",
            "K+B vs K",
            "K+B vs K+B (same color)"
        }

        return {
            game_id = ctx.gen.uuid(),
            white_player = ctx.gen.player_name(),
            black_player = ctx.gen.player_name(),
            white_elo = ctx.random.int(800, 2000),
            black_elo = ctx.random.int(800, 2000),
            move_number = ctx.random.int(40, 100),
            material_situation = ctx.random.choice(material_combos)
        }
    end
}
