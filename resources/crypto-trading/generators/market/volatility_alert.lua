return {
    metadata = {
        name = "market.volatility_alert",
        category = "MARKET",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "High volatility detected in market",
        text_template = "[{timestamp}] VOLATILITY_ALERT: {pair} volatility={volatility}% (threshold={threshold}%) price_change={change}%",
        tags = {"market", "volatility", "risk", "alert"},
        merge_groups = {"market_data"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}

        local threshold = ctx.random.int(3, 8)
        local volatility = threshold + ctx.random.float(1, 5)
        local change = ctx.random.float(-volatility, volatility)

        return {
            pair = ctx.random.choice(pairs),
            volatility = string.format("%.2f", volatility),
            threshold = threshold,
            change = string.format("%+.2f", change)
        }
    end
}
