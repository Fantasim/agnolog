-- Order Rejected Generator
-- Generates log entries when an order is rejected due to validation failure

return {
    metadata = {
        name = "orders.order_rejected",
        category = "ORDERS",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Order rejected due to validation failure",
        text_template = "[{timestamp}] ORDER_REJECTED: {order_id} {symbol} reason={reject_reason} error_code={error_code}",
        tags = {"orders", "rejection", "validation"},
        merge_groups = {"order_lifecycle"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        local reject_reasons = {
            "INSUFFICIENT_BALANCE",
            "INVALID_PRICE",
            "INVALID_QUANTITY",
            "POSITION_LIMIT_EXCEEDED",
            "SELF_TRADE_PREVENTION",
            "POST_ONLY_WOULD_CROSS",
            "MARKET_CLOSED",
            "DUPLICATE_ORDER_ID"
        }

        return {
            order_id = ctx.gen.uuid(),
            symbol = pair.symbol or "BTC/USDT",
            reject_reason = ctx.random.choice(reject_reasons),
            error_code = ctx.random.int(1000, 9999),
            user_id = "user_" .. ctx.random.int(10000, 99999)
        }
    end
}
