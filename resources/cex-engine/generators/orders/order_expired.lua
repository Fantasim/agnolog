-- Order Expired Generator
-- Generates log entries when an order expires due to time condition

return {
    metadata = {
        name = "orders.order_expired",
        category = "ORDERS",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Order expired due to time condition",
        text_template = "[{timestamp}] ORDER_EXPIRED: {order_id} {symbol} time_in_force={tif} age={age_seconds}s",
        tags = {"orders", "expiry"},
        merge_groups = {"order_lifecycle"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        return {
            order_id = ctx.gen.uuid(),
            symbol = pair.symbol or "BTC/USDT",
            time_in_force = ctx.random.choice({"GTD", "DAY"}),
            age_seconds = ctx.random.int(3600, 86400),
            filled_qty = "0.00000",
            expire_time = os.time() + 86400
        }
    end
}
