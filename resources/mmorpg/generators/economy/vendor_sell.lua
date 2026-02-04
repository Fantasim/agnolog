-- Economy Vendor Sell Generator

return {
    metadata = {
        name = "economy.vendor_sell",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Item sold to vendor",
        text_template = "[{timestamp}] VENDOR_SELL: {char_name} sold {item_name} x{quantity} for {price}g",
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

        local item_name = ctx.gen.item_name()
        local quantity = ctx.random.int(1, 10)
        local base_value = ctx.random.int(5, 200)
        -- Vendors buy at 25% of value
        local price = math.max(1, math.floor(base_value * 0.25 * quantity))

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_id = ctx.random.int(10000, 99999),
            item_name = item_name,
            quantity = quantity,
            price = price,
            zone = ctx.random.choice(zones)
        }
    end
}
