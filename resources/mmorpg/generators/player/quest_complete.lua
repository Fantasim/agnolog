-- Player Quest Complete Generator

return {
    metadata = {
        name = "player.quest_complete",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Quest completed",
        text_template = "[{timestamp}] QUEST_COMPLETE: {char_name} completed \"{quest_name}\" (+{xp} XP, +{gold}g)",
        tags = {"player", "quest", "reward"}
    },

    generate = function(ctx, args)
        local quest_verbs = {"Defeat", "Slay", "Collect", "Gather", "Deliver"}
        local quest_targets = {"the Wolves", "the Bandits", "the Undead"}

        if ctx.data.quests and ctx.data.quests.quest_types then
            local qd = ctx.data.quests.quest_types
            if qd.verbs then quest_verbs = qd.verbs end
            if qd.targets then quest_targets = qd.targets end
        end

        local quest_name = ctx.random.choice(quest_verbs) .. " " .. ctx.random.choice(quest_targets)
        local level = ctx.random.int(1, 60)

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            quest_id = ctx.random.int(1000, 99999),
            quest_name = quest_name,
            xp = level * ctx.random.int(80, 120),
            gold = level * ctx.random.int(5, 15),
            time_to_complete = ctx.random.int(60, 3600)
        }
    end
}
