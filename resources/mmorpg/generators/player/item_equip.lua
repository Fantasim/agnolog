-- Player Item Equip Generator

return {
    metadata = {
        name = "player.item_equip",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Equipment change",
        text_template = "[{timestamp}] EQUIP: {char_name} equipped [{rarity}] {item_name} in {slot}",
        tags = {"player", "inventory", "equipment"},
        merge_groups = {"item_events"}
    },

    slots = {
        "Head", "Shoulders", "Chest", "Hands", "Legs", "Feet",
        "Main Hand", "Off Hand", "Ranged", "Trinket", "Ring", "Neck", "Back"
    },

    generate = function(ctx, args)
        local slots = {
            "Head", "Shoulders", "Chest", "Hands", "Legs", "Feet",
            "Main Hand", "Off Hand", "Ranged", "Trinket", "Ring", "Neck", "Back"
        }
        local rarities = {"Common", "Uncommon", "Rare", "Epic"}
        local item_types = {"Sword", "Axe", "Plate Helm", "Leather Chest", "Mail Gloves"}

        local rarity = ctx.random.choice(rarities)
        local prefixes = ctx.data.items and ctx.data.items.item_prefixes and ctx.data.items.item_prefixes[rarity]
        local prefix = prefixes and ctx.random.choice(prefixes) or "Basic"

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_id = ctx.random.int(10000, 99999),
            item_name = prefix .. " " .. ctx.random.choice(item_types),
            rarity = rarity,
            slot = ctx.random.choice(slots),
            item_level = ctx.random.int(1, 60)
        }
    end
}
