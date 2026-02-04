-- Player Character Create Generator

return {
    metadata = {
        name = "player.character_create",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "New character creation",
        text_template = "[{timestamp}] CHAR_CREATE: {username} created {char_name} ({race} {class})",
        tags = {"player", "character"}
    },

    generate = function(ctx, args)
        local classes = {"Warrior", "Paladin", "Hunter", "Rogue", "Priest", "Shaman", "Mage", "Warlock", "Druid"}
        local races = {"Human", "Dwarf", "Night Elf", "Gnome", "Orc", "Undead", "Tauren", "Troll"}

        return {
            username = args.username or ctx.gen.player_name(),
            char_name = ctx.gen.character_name(),
            class = ctx.random.choice(classes),
            race = ctx.random.choice(races),
            customization = {
                skin_color = ctx.random.int(1, 10),
                hair_style = ctx.random.int(1, 20),
                hair_color = ctx.random.int(1, 15)
            }
        }
    end
}
