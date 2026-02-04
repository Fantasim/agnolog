-- Economy Auction Bid Generator

return {
    metadata = {
        name = "economy.auction_bid",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Bid placed on auction",
        text_template = "[{timestamp}] AUCTION_BID: {char_name} bid {amount}g on [{rarity}] {item_name}",
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
        local current_bid = math.floor(base_value * (0.3 + ctx.random.float() * 0.7))
        local new_bid = math.floor(current_bid * (1.05 + ctx.random.float() * 0.45))

        local has_previous_bidder = ctx.random.float() > 0.3

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            item_id = ctx.random.int(10000, 99999),
            item_name = ctx.gen.item_name(),
            rarity = rarity,
            amount = new_bid,
            previous_bid = current_bid,
            previous_bidder = has_previous_bidder and ctx.gen.character_name() or nil
        }
    end
}
