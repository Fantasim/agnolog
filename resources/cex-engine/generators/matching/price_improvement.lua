-- Price Improvement Generator
-- Generates log entries when an order is executed with price improvement

return {
    metadata = {
        name = "matching.price_improvement",
        category = "MATCHING",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Order executed with price improvement",
        text_template = "[{timestamp}] PRICE_IMPROVEMENT: {order_id} improved by {improvement_bps}bps (limit={limit_price} exec={exec_price})",
        tags = {"matching", "execution_quality", "price_improvement"},
        merge_groups = {"matches"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        local limit_price = ctx.random.float(40000, 50000)
        local side = ctx.random.choice({"BUY", "SELL"})
        local improvement_bps = ctx.random.int(5, 100)
        local exec_price = side == "BUY"
            and limit_price * (1 - improvement_bps / 10000)
            or limit_price * (1 + improvement_bps / 10000)

        return {
            order_id = ctx.gen.uuid(),
            symbol = pair.symbol or "BTC/USDT",
            side = side,
            limit_price = string.format("%.2f", limit_price),
            exec_price = string.format("%.2f", exec_price),
            improvement_bps = improvement_bps,
            quantity = string.format("%.5f", ctx.random.float(0.01, 1.0)),
            saved_amount = string.format("%.2f", math.abs(exec_price - limit_price) * ctx.random.float(0.01, 1.0))
        }
    end
}
