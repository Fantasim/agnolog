return {
    metadata = {
        name = "game.en_passant",
        category = "GAME",
        severity = "DEBUG",
        recurrence = "RARE",
        description = "En passant capture performed",
        text_template = "[{timestamp}] EN_PASSANT: {player} captured en passant on {square}",
        tags = {"game", "move", "en_passant", "capture"},
        merge_groups = {"game_moves"}
    },
    generate = function(ctx, args)
        local en_passant_squares = {"a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3", "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6"}

        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            square = ctx.random.choice(en_passant_squares),
            move_number = ctx.random.int(10, 30),
            color = ctx.random.choice({"white", "black"})
        }
    end
}
