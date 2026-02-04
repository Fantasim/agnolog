-- Player Item Pickup Generator

return {
    metadata = {
        name = "player.item_pickup",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Item picked up",
        text_template = "[{timestamp}] PICKUP: {char_name} looted [{rarity}] {item_name} x{quantity}",
        tags = {"player", "inventory", "loot"},
        merge_groups = {"item_events"}
    },

    generate = function(ctx, args)
        local rarities = {"Common", "Uncommon", "Rare", "Epic"}
        local item_types = {"Sword", "Axe", "Staff", "Cloth Chest", "Leather Helm", "Health Potion"}
        local sources = {"loot", "quest_reward", "mail", "trade"}

        local rarity = ctx.random.choice(rarities)
        local item_type = ctx.random.choice(item_types)
        local prefixes = ctx.data.items and ctx.data.items.item_prefixes and ctx.data.items.item_prefixes[rarity]
        local prefix = prefixes and ctx.random.choice(prefixes) or "Basic"

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_id = ctx.random.int(10000, 99999),
            item_name = prefix .. " " .. item_type,
            rarity = rarity,
            quantity = ctx.random.int(1, 20),
            source = ctx.random.choice(sources)
        }
    end
}
