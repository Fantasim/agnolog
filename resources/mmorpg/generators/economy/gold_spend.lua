-- Economy Gold Spend Generator

return {
    metadata = {
        name = "economy.gold_spend",
        category = "ECONOMY",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Gold spent",
        text_template = "[{timestamp}] GOLD_SPEND: {char_name} -{amount}g (target: {target})",
        tags = {"economy", "gold", "transaction"},
        merge_groups = {"gold_flow"}
    },

    generate = function(ctx, args)
        local targets = {"vendor_purchase", "auction_bid", "auction_buyout", "repair",
            "training", "travel", "respec", "guild_bank"}

        local amounts = {
            vendor_purchase = {1, 500},
            auction_bid = {10, 5000},
            auction_buyout = {50, 20000},
            repair = {5, 200},
            training = {10, 1000},
            travel = {1, 50},
            respec = {50, 500},
            guild_bank = {100, 10000}
        }

        if ctx.data.constants and ctx.data.constants.economy then
            local ec = ctx.data.constants.economy
            if ec.gold_spend_targets then targets = ec.gold_spend_targets end
        end

        local target = ctx.random.choice(targets)
        local range = amounts[target] or {1, 100}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            amount = ctx.random.int(range[1], range[2]),
            target = target
        }
    end
}
