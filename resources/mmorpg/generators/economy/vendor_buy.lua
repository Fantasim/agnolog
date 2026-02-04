-- Economy Vendor Buy Generator

return {
    metadata = {
        name = "economy.vendor_buy",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Item purchased from vendor",
        text_template = "[{timestamp}] VENDOR_BUY: {char_name} bought {item_name} x{quantity} for {price}g",
        tags = {"economy", "vendor", "item"},
        merge_groups = {"vendor_transactions"}
    },

    generate = function(ctx, args)
        local zones = {"Stormwind", "Orgrimmar", "Ironforge", "Thunder Bluff"}

        if ctx.data.world and ctx.data.world.cities then
            zones = {}
            for _, city in ipairs(ctx.data.world.cities) do
                table.insert(zones, city.name or city)
            end
        end

        -- Consumable items from vendors
        local consumables = {"Health Potion", "Mana Potion", "Bandage", "Food", "Water",
            "Reagent", "Arrows", "Bullets", "Fishing Bait", "Repair Bot"}

        -- consumables.yaml has nested structure: data.consumables.consumables
        local cons_data = ctx.data.items and ctx.data.items.consumables and ctx.data.items.consumables.consumables
        if cons_data then
            consumables = {}
            for _, c in ipairs(cons_data) do
                table.insert(consumables, c.name or c)
            end
            if #consumables == 0 then
                consumables = {"Health Potion", "Mana Potion", "Bandage", "Food", "Water"}
            end
        end

        local item_name = ctx.random.choice(consumables)
        local quantity = ctx.random.int(1, 20)
        local unit_price = ctx.random.int(1, 25)
        local price = unit_price * quantity

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_id = ctx.random.int(10000, 99999),
            item_name = item_name,
            quantity = quantity,
            price = price,
            vendor_name = "Vendor " .. ctx.gen.character_name(),
            zone = ctx.random.choice(zones)
        }
    end
}
