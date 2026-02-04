-- Combat Arena Start Generator

return {
    metadata = {
        name = "combat.arena_start",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Arena match started",
        text_template = "[{timestamp}] ARENA_START: {team1} vs {team2} in {arena} ({bracket})",
        tags = {"combat", "arena", "pvp"},
        merge_groups = {"arena"}
    },

    generate = function(ctx, args)
        local brackets = {"2v2", "3v3", "5v5"}
        local bracket = ctx.random.choice(brackets)
        local team_size = tonumber(string.sub(bracket, 1, 1))

        local team1 = {}
        local team2 = {}

        for i = 1, team_size do
            table.insert(team1, ctx.gen.character_name())
            table.insert(team2, ctx.gen.character_name())
        end

        local arenas = {"Blade's Edge Arena", "Nagrand Arena", "Ruins of Lordaeron"}

        if ctx.data.world and ctx.data.world.battlegrounds then
            -- Check for arenas specifically
            for _, bg in ipairs(ctx.data.world.battlegrounds) do
                if bg.type == "arena" then
                    table.insert(arenas, bg.name or bg)
                end
            end
        end

        return {
            team1 = table.concat(team1, ", "),
            team1_members = team1,
            team2 = table.concat(team2, ", "),
            team2_members = team2,
            bracket = bracket,
            arena = ctx.random.choice(arenas),
            team1_rating = ctx.random.int(1000, 2500),
            team2_rating = ctx.random.int(1000, 2500)
        }
    end
}
