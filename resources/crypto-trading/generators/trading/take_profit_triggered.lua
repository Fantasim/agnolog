return {
    metadata = {
        name = "trading.take_profit_triggered",
        category = "TRADING",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Take profit order triggered to lock in gains",
        text_template = "[{timestamp}] TAKE_PROFIT: {position_id} {pair} triggered @ {trigger_price} profit={profit} ({profit_percent}%)",
        tags = {"position", "trading", "take_profit", "profit"},
        merge_groups = {"positions"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}

        local pair = ctx.random.choice(pairs)
        local is_btc = string.find(pair, "BTC") ~= nil
        local entry_price = is_btc and ctx.random.float(40000, 70000) or ctx.random.float(1000, 4000)
        local profit_percent = ctx.random.float(2, 10)
        local trigger_price = entry_price * (1 + profit_percent / 100)
        local size = ctx.random.float(0.01, 1)
        local profit = (trigger_price - entry_price) * size

        return {
            position_id = ctx.gen.uuid(),
            pair = pair,
            trigger_price = string.format("%.2f", trigger_price),
            profit = string.format("+%.2f", profit),
            profit_percent = string.format("+%.2f", profit_percent)
        }
    end
}
