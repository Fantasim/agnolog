-- Order Cancelled Generator
-- Generates log entries when an order is cancelled by user or system

return {
    metadata = {
        name = "orders.order_cancelled",
        category = "ORDERS",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Order cancelled by user or system",
        text_template = "[{timestamp}] ORDER_CANCELLED: {order_id} {symbol} reason={cancel_reason} filled={filled_qty}/{total_qty}",
        tags = {"orders", "cancellation"},
        merge_groups = {"order_lifecycle"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        local cancel_reasons = {
            "USER_REQUESTED",
            "INSUFFICIENT_MARGIN",
            "TIMEOUT",
            "RISK_LIMIT",
            "SYSTEM_MAINTENANCE"
        }

        local total_qty = ctx.random.float(0.1, 10.0)
        local filled_qty = ctx.random.float(0, total_qty * 0.5)

        return {
            order_id = ctx.gen.uuid(),
            symbol = pair.symbol or "BTC/USDT",
            cancel_reason = ctx.random.choice(cancel_reasons),
            filled_qty = string.format("%.5f", filled_qty),
            total_qty = string.format("%.5f", total_qty),
            time_in_book_ms = ctx.random.int(100, 300000)
        }
    end
}
