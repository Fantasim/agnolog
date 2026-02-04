-- Player Inventory Full Generator

return {
    metadata = {
        name = "player.inventory_full",
        category = "PLAYER",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Inventory full warning",
        text_template = "[{timestamp}] INV_FULL: {char_name} inventory full, could not loot {item_name}",
        tags = {"player", "inventory", "warning"}
    },

    generate = function(ctx, args)
        local rarities = {"Common", "Uncommon", "Rare", "Epic"}
        local item_types = {"Sword", "Staff", "Plate Helm", "Health Potion"}

        local rarity = ctx.random.choice(rarities)

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_name = "Basic " .. ctx.random.choice(item_types),
            item_rarity = rarity,
            slots_used = ctx.random.int(115, 120),
            slots_total = 120
        }
    end
}
