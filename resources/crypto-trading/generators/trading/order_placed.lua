return {
    metadata = {
        name = "trading.order_placed",
        category = "TRADING",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Trading bot places a buy or sell order",
        text_template = "[{timestamp}] ORDER_PLACED: {order_id} {side} {quantity} {pair} @ {price} ({order_type}) on {exchange}",
        tags = {"order", "trading", "execution"},
        merge_groups = {"orders"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}
        local exchanges = ctx.data.exchanges.exchanges or {"Binance", "Coinbase Pro"}
        local order_types = ctx.data.constants.order_types or {"market", "limit"}
        local sides = ctx.data.constants.order_sides or {"buy", "sell"}

        local pair = ctx.random.choice(pairs)
        local side = ctx.random.choice(sides)
        local is_btc = string.find(pair, "BTC") ~= nil

        local base_price = is_btc and ctx.random.float(40000, 70000) or ctx.random.float(1000, 4000)
        local quantity = is_btc and ctx.random.float(0.001, 0.5) or ctx.random.float(0.01, 5)

        return {
            order_id = ctx.gen.uuid(),
            side = string.upper(side),
            quantity = string.format("%.6f", quantity),
            pair = pair,
            price = string.format("%.2f", base_price),
            order_type = ctx.random.choice(order_types),
            exchange = ctx.random.choice(exchanges)
        }
    end
}
