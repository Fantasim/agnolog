-- Partial Fill Generator
-- Generates log entries when an order is partially filled by the matching engine

return {
    metadata = {
        name = "matching.partial_fill",
        category = "MATCHING",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Order partially filled by matching engine",
        text_template = "[{timestamp}] PARTIAL_FILL: {order_id} {symbol} filled={filled_qty}/{total_qty} avg_price={avg_price} remaining={remaining_qty}",
        tags = {"matching", "partial_fill"},
        merge_groups = {"fills"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        local total_qty = ctx.random.float(1.0, 100.0)
        local fill_ratio = ctx.random.float(0.1, 0.9)
        local filled_qty = total_qty * fill_ratio

        return {
            order_id = ctx.gen.uuid(),
            symbol = pair.symbol or "BTC/USDT",
            filled_qty = string.format("%.5f", filled_qty),
            total_qty = string.format("%.5f", total_qty),
            remaining_qty = string.format("%.5f", total_qty - filled_qty),
            avg_price = string.format("%.2f", ctx.random.float(30000, 60000)),
            fill_count = ctx.random.int(1, 5),
            cumulative_value = string.format("%.2f", filled_qty * ctx.random.float(30000, 60000))
        }
    end
}
