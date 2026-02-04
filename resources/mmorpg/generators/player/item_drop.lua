-- Player Item Drop Generator

return {
    metadata = {
        name = "player.item_drop",
        category = "PLAYER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Item dropped/destroyed",
        text_template = "[{timestamp}] DROP: {char_name} dropped {item_name} x{quantity}",
        tags = {"player", "inventory"},
        merge_groups = {"item_events"}
    },

    generate = function(ctx, args)
        local item_types = {"Sword", "Axe", "Staff", "Cloth Chest", "Health Potion"}
        local zones = {"Elwynn Forest", "Westfall", "Duskwood"}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_id = ctx.random.int(10000, 99999),
            item_name = "Basic " .. ctx.random.choice(item_types),
            quantity = ctx.random.int(1, 10),
            zone = ctx.random.choice(zones)
        }
    end
}
