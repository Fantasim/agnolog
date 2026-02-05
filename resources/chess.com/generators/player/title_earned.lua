return {
    metadata = {
        name = "player.title_earned",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "RARE",
        description = "Player earns a chess title",
        text_template = "[{timestamp}] TITLE: {username} earned title {title}!",
        tags = {"player", "title", "achievement"},
        merge_groups = {"player_events"}
    },
    generate = function(ctx, args)
        local titles = ctx.data.players.titles.fide_titles
        local title = ctx.random.choice(titles)

        return {
            username = ctx.gen.player_name(),
            title_code = title.code,
            title_name = title.name,
            current_rating = ctx.random.int(title.rating_threshold, title.rating_threshold + 200),
            games_played = ctx.random.int(500, 5000),
            title_type = "FIDE"
        }
    end
}
