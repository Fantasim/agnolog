-- Player Quest Accept Generator

return {
    metadata = {
        name = "player.quest_accept",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Quest accepted",
        text_template = "[{timestamp}] QUEST_ACCEPT: {char_name} accepted \"{quest_name}\"",
        tags = {"player", "quest"}
    },

    generate = function(ctx, args)
        local quest_types = {"Kill", "Collect", "Escort", "Delivery", "Exploration"}
        local quest_verbs = {"Defeat", "Slay", "Collect", "Gather", "Deliver", "Explore"}
        local quest_targets = {"the Wolves", "the Bandits", "the Undead", "the Ancient Evil"}

        if ctx.data.quests and ctx.data.quests.quest_types then
            local qd = ctx.data.quests.quest_types
            if qd.types then quest_types = qd.types end
            if qd.verbs then quest_verbs = qd.verbs end
            if qd.targets then quest_targets = qd.targets end
        end

        local quest_name = ctx.random.choice(quest_verbs) .. " " .. ctx.random.choice(quest_targets)
        local zones = {"Elwynn Forest", "Westfall", "Duskwood"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            quest_id = ctx.random.int(1000, 99999),
            quest_name = quest_name,
            quest_level = ctx.random.int(1, 60),
            zone = ctx.random.choice(zones),
            quest_type = ctx.random.choice(quest_types)
        }
    end
}
