return {
    metadata = {
        name = "account.balance_update",
        category = "ACCOUNT",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Account balance has changed",
        text_template = "[{timestamp}] BALANCE: {currency} {prev_balance} -> {new_balance} ({change}) on {exchange}",
        tags = {"account", "balance", "wallet"},
        merge_groups = {"account_balance"}
    },

    generate = function(ctx, args)
        local currencies = ctx.data.cryptocurrencies.base_currencies or {"BTC", "ETH", "USDT"}
        local exchanges = ctx.data.exchanges.exchanges or {"Binance", "Coinbase Pro"}

        local currency = ctx.random.choice(currencies)
        local is_stable = currency == "USDT" or currency == "USDC"
        local prev_balance = is_stable and ctx.random.float(1000, 50000) or ctx.random.float(0.1, 10)
        local change = prev_balance * ctx.random.float(-0.1, 0.1)
        local new_balance = prev_balance + change

        local decimals = is_stable and 2 or 6

        return {
            currency = currency,
            prev_balance = string.format("%." .. decimals .. "f", prev_balance),
            new_balance = string.format("%." .. decimals .. "f", new_balance),
            change = string.format("%+." .. decimals .. "f", change),
            exchange = ctx.random.choice(exchanges)
        }
    end
}
