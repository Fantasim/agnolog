-- Economy Auction List Generator

return {
    metadata = {
        name = "economy.auction_list",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Item listed on auction",
        text_template = "[{timestamp}] AUCTION_LIST: {char_name} listed [{rarity}] {item_name} x{quantity} at {price}g",
        tags = {"economy", "auction", "item"}
    },

    generate = function(ctx, args)
        local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary"}
        local rarity_values = {
            Common = {10, 50},
            Uncommon = {50, 200},
            Rare = {200, 1000},
            Epic = {1000, 5000},
            Legendary = {5000, 50000}
        }

        if ctx.data.items and ctx.data.items.rarities then
            rarities = {}
            for _, r in ipairs(ctx.data.items.rarities) do
                table.insert(rarities, r.name or r)
            end
        end

        local rarity = ctx.random.choice(rarities)
        local value_range = rarity_values[rarity] or {10, 100}
        local base_value = ctx.random.int(value_range[1], value_range[2])
        local price = math.floor(base_value * (0.5 + ctx.random.float() * 2.5))

        local min_price = 1
        local max_price = 999999
        if ctx.data.constants and ctx.data.constants.economy then
            min_price = ctx.data.constants.economy.min_auction_price or 1
            max_price = ctx.data.constants.economy.max_auction_price or 999999
        end
        price = math.max(min_price, math.min(price, max_price))

        local quantity = ctx.random.int(1, 20)
        local has_buyout = ctx.random.float() > 0.3

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_id = ctx.random.int(10000, 99999),
            item_name = ctx.gen.item_name(),
            rarity = rarity,
            quantity = quantity,
            price = price,
            buyout = has_buyout and math.floor(price * 1.5) or nil,
            duration = ctx.random.choice({12, 24, 48}),
            deposit = math.floor(price * 0.05)
        }
    end
}
