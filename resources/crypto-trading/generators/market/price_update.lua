return {
    metadata = {
        name = "market.price_update",
        category = "MARKET",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Real-time price tick received from exchange",
        text_template = "[{timestamp}] PRICE: {pair} bid={bid} ask={ask} last={last} vol_24h={volume}",
        tags = {"market", "price", "ticker"},
        merge_groups = {"market_data"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}

        local pair = ctx.random.choice(pairs)
        local is_btc = string.find(pair, "BTC") ~= nil
        local base_price = is_btc and ctx.random.float(40000, 70000) or ctx.random.float(1000, 4000)
        local spread = base_price * 0.0005

        return {
            pair = pair,
            bid = string.format("%.2f", base_price - spread),
            ask = string.format("%.2f", base_price + spread),
            last = string.format("%.2f", base_price),
            volume = string.format("%.0f", ctx.random.float(1000000, 50000000))
        }
    end
}
