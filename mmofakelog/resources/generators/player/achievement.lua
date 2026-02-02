-- Player Achievement Generator

return {
    metadata = {
        name = "player.achievement",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Achievement unlocked",
        text_template = "[{timestamp}] ACHIEVEMENT: {char_name} earned \"{achievement_name}\" (+{points} pts)",
        tags = {"player", "progression", "achievement"}
    },

    achievements = {
        {name = "Explorer", points = 10},
        {name = "Dungeon Master", points = 20},
        {name = "Dragon Slayer", points = 50},
        {name = "Master Crafter", points = 15},
        {name = "PvP Champion", points = 25},
        {name = "Loremaster", points = 30},
        {name = "Speed Runner", points = 10},
        {name = "Perfectionist", points = 40},
        {name = "Guild Leader", points = 15},
        {name = "First Blood", points = 5},
        {name = "Undying", points = 25},
        {name = "The Insane", points = 100}
    },

    generate = function(ctx, args)
        local achievements = {
            {name = "Explorer", points = 10},
            {name = "Dungeon Master", points = 20},
            {name = "Dragon Slayer", points = 50},
            {name = "Master Crafter", points = 15},
            {name = "PvP Champion", points = 25},
            {name = "Loremaster", points = 30},
            {name = "Speed Runner", points = 10},
            {name = "Perfectionist", points = 40},
            {name = "Guild Leader", points = 15},
            {name = "First Blood", points = 5},
            {name = "Undying", points = 25},
            {name = "The Insane", points = 100}
        }

        local achievement = ctx.random.choice(achievements)
        local categories = {"Exploration", "Dungeons", "PvP", "Quests", "Professions"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            achievement_name = achievement.name,
            achievement_id = ctx.random.int(1000, 9999),
            points = achievement.points,
            category = ctx.random.choice(categories)
        }
    end
}
