-- Economy Auction Expire Generator

return {
    metadata = {
        name = "economy.auction_expire",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Auction expired",
        text_template = "[{timestamp}] AUCTION_EXPIRE: {char_name}'s [{rarity}] {item_name} expired (no bids)",
        tags = {"economy", "auction", "item"},
        merge_groups = {"auction_house"}
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
                table.insert(rarities, r.id or r.name or r)
            end
            if #rarities == 0 then
                rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary"}
            end
        end

        local rarity = ctx.random.choice(rarities)
        local value_range = rarity_values[rarity] or {10, 100}
        local base_value = ctx.random.int(value_range[1], value_range[2])
        local asking_price = math.floor(base_value * (1.5 + ctx.random.float() * 3.5))

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_id = ctx.random.int(10000, 99999),
            item_name = ctx.gen.item_name(),
            rarity = rarity,
            asking_price = asking_price,
            deposit_lost = math.floor(base_value * 0.05)
        }
    end
}
