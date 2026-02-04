-- Combat Arena End Generator

return {
    metadata = {
        name = "combat.arena_end",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Arena match ended",
        text_template = "[{timestamp}] ARENA_END: {winner} defeated {loser} ({duration}s)",
        tags = {"combat", "arena", "pvp"},
        merge_groups = {"arena"}
    },

    generate = function(ctx, args)
        local arenas = {"Blade's Edge Arena", "Nagrand Arena", "Ruins of Lordaeron"}

        if ctx.data.world and ctx.data.world.battlegrounds then
            for _, bg in ipairs(ctx.data.world.battlegrounds) do
                if bg.type == "arena" then
                    table.insert(arenas, bg.name or bg)
                end
            end
        end

        return {
            winner = args.winner or ctx.gen.character_name(),
            loser = args.loser or ctx.gen.character_name(),
            duration = ctx.random.int(30, 600),
            rating_change = ctx.random.int(-30, 30),
            arena = ctx.random.choice(arenas)
        }
    end
}
