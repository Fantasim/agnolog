-- Player Item Use Generator

return {
    metadata = {
        name = "player.item_use",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Item consumed/used",
        text_template = "[{timestamp}] USE: {char_name} used {item_name}",
        tags = {"player", "inventory", "consumable"}
    },

    generate = function(ctx, args)
        local consumables = {"Health Potion", "Mana Potion", "Elixir", "Flask", "Food", "Drink", "Scroll"}
        local effects = {"heal", "buff", "restore_mana", "teleport"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_id = ctx.random.int(10000, 99999),
            item_name = ctx.random.choice(consumables),
            effect = ctx.random.choice(effects)
        }
    end
}
