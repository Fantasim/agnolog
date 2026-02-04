-- Economy Tax Collected Generator

return {
    metadata = {
        name = "economy.tax_collected",
        category = "ECONOMY",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Transaction tax collected",
        text_template = "[{timestamp}] TAX: {amount}g collected from {char_name} ({type})",
        tags = {"economy", "tax", "transaction"}
    },

    generate = function(ctx, args)
        local tax_types = {"auction_fee", "auction_cut", "mail_fee", "guild_bank_fee",
            "respec_cost", "flight_cost"}

        local amounts = {
            auction_fee = {1, 100},
            auction_cut = {1, 500},
            mail_fee = {1, 5},
            guild_bank_fee = {1, 10},
            respec_cost = {10, 50},
            flight_cost = {1, 20}
        }

        local tax_type = ctx.random.choice(tax_types)
        local range = amounts[tax_type] or {1, 10}

        return {
            char_name = args.char_name or ctx.gen.character_name(),
            amount = ctx.random.int(range[1], range[2]),
            type = tax_type
        }
    end
}
