return {
    metadata = {
        name = "matchmaking.queue_enter",
        category = "MATCHMAKING",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Player enters matchmaking queue",
        text_template = "[{timestamp}] QUEUE_ENTER: {username} ({elo}) queued for {time_control}",
        tags = {"matchmaking", "queue"},
        merge_groups = {"matchmaking"}
    },
    generate = function(ctx, args)
        local time_controls = ctx.data.game.time_controls
        local variants = ctx.data.game.variants

        -- Flatten time controls
        local all_time_controls = {}
        for _, category in pairs(time_controls) do
            for _, tc in ipairs(category) do
                table.insert(all_time_controls, tc)
            end
        end

        local time_control = ctx.random.choice(all_time_controls)
        local variant = ctx.random.choice(variants)

        return {
            username = ctx.gen.player_name(),
            elo = ctx.random.int(800, 2800),
            time_control = time_control.name,
            time_category = time_control.category,
            variant = variant.id,
            rated = ctx.random.float(0, 1) < 0.85,
            queue_id = ctx.gen.uuid()
        }
    end
}
