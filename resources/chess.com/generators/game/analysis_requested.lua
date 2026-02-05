return {
    metadata = {
        name = "game.analysis_requested",
        category = "GAME",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player requests computer analysis of game",
        text_template = "[{timestamp}] ANALYSIS: {player} requested analysis for game {game_id}",
        tags = {"game", "analysis"},
        merge_groups = {"game_analysis"}
    },
    generate = function(ctx, args)
        return {
            game_id = ctx.gen.uuid(),
            player = ctx.gen.player_name(),
            player_elo = ctx.random.int(800, 2800),
            moves_analyzed = ctx.random.int(20, 80),
            accuracy = ctx.random.int(60, 99),
            blunders = ctx.random.int(0, 5),
            mistakes = ctx.random.int(0, 10),
            inaccuracies = ctx.random.int(0, 15),
            analysis_depth = ctx.random.int(15, 25)
        }
    end
}
