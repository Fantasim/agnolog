return {
    metadata = {
        name = "game.brilliant_move",
        category = "GAME",
        severity = "INFO",
        recurrence = "RARE",
        description = "Player makes a brilliant move",
        text_template = "[{timestamp}] BRILLIANT: {player} ({elo}) played brilliant move {move}!",
        tags = {"game", "brilliant", "best_move"},
        merge_groups = {"game_analysis"}
    },
    generate = function(ctx, args)
        local brilliant_types = {
            "sacrifice",
            "quiet_move",
            "only_winning_move",
            "counterintuitive",
            "zugzwang"
        }

        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            elo = ctx.random.int(1600, 2800),
            move = ctx.random.choice({"Rxf7!!", "Qh6!!", "Nxe6!!", "Bxh7+!!", "f6!!"}),
            move_number = ctx.random.int(15, 45),
            move_type = ctx.random.choice(brilliant_types),
            eval_before = ctx.random.float(-1, 3),
            eval_after = ctx.random.float(4, 10),
            difficulty = ctx.random.choice({"hard", "very_hard", "nearly_impossible"})
        }
    end
}
