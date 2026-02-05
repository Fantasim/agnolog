return {
    metadata = {
        name = "player.club_join",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Player joins a chess club",
        text_template = "[{timestamp}] CLUB_JOIN: {username} joined {club_name}",
        tags = {"player", "club", "social"},
        merge_groups = {"player_events"}
    },
    generate = function(ctx, args)
        local clubs = ctx.data.clubs.club_names

        return {
            username = ctx.gen.player_name(),
            club_name = ctx.random.choice(clubs),
            club_id = ctx.gen.uuid(),
            player_elo = ctx.random.int(800, 2800),
            club_size = ctx.random.int(10, 10000),
            requires_approval = ctx.random.float(0, 1) < 0.3
        }
    end
}
