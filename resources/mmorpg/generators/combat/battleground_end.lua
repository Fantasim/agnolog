-- Combat Battleground End Generator

return {
    metadata = {
        name = "combat.battleground_end",
        category = "COMBAT",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Battleground concluded",
        text_template = "[{timestamp}] BG_END: {bg_name} - {winner} wins (score: {score})",
        tags = {"combat", "battleground", "pvp"},
        merge_groups = {"battlegrounds"}
    },

    generate = function(ctx, args)
        local battlegrounds = {
            "Warsong Gulch", "Arathi Basin", "Alterac Valley",
            "Eye of the Storm", "Strand of the Ancients"
        }

        if ctx.data.world and ctx.data.world.battlegrounds then
            local loaded = {}
            for _, bg in ipairs(ctx.data.world.battlegrounds) do
                if bg.type ~= "arena" then
                    table.insert(loaded, bg.name or bg)
                end
            end
            if #loaded > 0 then
                battlegrounds = loaded
            end
        end

        local bg = ctx.random.choice(battlegrounds) or "Warsong Gulch"
        local winner = ctx.random.choice({"Alliance", "Horde"})

        -- Score format depends on BG type
        local score
        if string.find(bg, "Gulch") then
            score = ctx.random.int(0, 3) .. "-" .. ctx.random.int(0, 3)
        elseif string.find(bg, "Basin") or string.find(bg, "Eye") then
            score = ctx.random.int(1000, 2000) .. "-" .. ctx.random.int(500, 1999)
        else
            score = ctx.random.int(100, 600) .. "-" .. ctx.random.int(100, 600)
        end

        return {
            bg_name = bg,
            winner = winner,
            score = score,
            duration_minutes = ctx.random.int(10, 45),
            honor_gained = ctx.random.int(100, 500)
        }
    end
}
