return {
    metadata = {
        name = "player.club_leave",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Player leaves a chess club",
        text_template = "[{timestamp}] CLUB_LEAVE: {username} left {club_name}",
        tags = {"player", "club", "social"},
        merge_groups = {"player_events"}
    },
    generate = function(ctx, args)
        local clubs = ctx.data.clubs.club_names

        return {
            username = ctx.gen.player_name(),
            club_name = ctx.random.choice(clubs),
            club_id = ctx.gen.uuid(),
            membership_duration_days = ctx.random.int(1, 365),
            games_played_in_club = ctx.random.int(0, 100)
        }
    end
}
