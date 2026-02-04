-- Player Quest Abandon Generator

return {
    metadata = {
        name = "player.quest_abandon",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Quest abandoned",
        text_template = "[{timestamp}] QUEST_ABANDON: {char_name} abandoned \"{quest_name}\"",
        tags = {"player", "quest"},
        merge_groups = {"quests"}
    },

    generate = function(ctx, args)
        local quest_verbs = {"Defeat", "Slay", "Collect", "Gather"}
        local quest_targets = {"the Wolves", "the Bandits", "the Undead"}

        if ctx.data.quests and ctx.data.quests.quest_types then
            local qd = ctx.data.quests.quest_types
            if qd.verbs then quest_verbs = qd.verbs end
            if qd.targets then quest_targets = qd.targets end
        end

        local quest_name = ctx.random.choice(quest_verbs) .. " " .. ctx.random.choice(quest_targets)

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            quest_id = ctx.random.int(1000, 99999),
            quest_name = quest_name,
            progress_percent = ctx.random.int(0, 80)
        }
    end
}
