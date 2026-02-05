return {
    metadata = {
        name = "account.deposit_received",
        category = "ACCOUNT",
        severity = "INFO",
        recurrence = "RARE",
        description = "Funds deposited to trading account",
        text_template = "[{timestamp}] DEPOSIT: {amount} {currency} received on {exchange} tx={tx_hash}",
        tags = {"account", "deposit", "funding"},
        merge_groups = {"account_balance"}
    },

    generate = function(ctx, args)
        local currencies = ctx.data.cryptocurrencies.base_currencies or {"BTC", "ETH", "USDT"}
        local exchanges = ctx.data.exchanges.exchanges or {"Binance", "Coinbase Pro"}

        local currency = ctx.random.choice(currencies)
        local is_stable = currency == "USDT" or currency == "USDC"
        local amount = is_stable and ctx.random.float(500, 10000) or ctx.random.float(0.05, 2)
        local decimals = is_stable and 2 or 6

        return {
            amount = string.format("%." .. decimals .. "f", amount),
            currency = currency,
            exchange = ctx.random.choice(exchanges),
            tx_hash = "0x" .. ctx.gen.hex_string(64)
        }
    end
}
