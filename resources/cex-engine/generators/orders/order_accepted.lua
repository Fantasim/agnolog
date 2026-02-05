-- Order Accepted Generator
-- Generates log entries when an order passes validation and enters the order book

return {
    metadata = {
        name = "orders.order_accepted",
        category = "ORDERS",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Order passed validation and entered order book",
        text_template = "[{timestamp}] ORDER_ACCEPTED: {order_id} {symbol} entered book at price_level={price_level}",
        tags = {"orders", "validation", "acceptance"},
        merge_groups = {"order_lifecycle"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        return {
            order_id = ctx.gen.uuid(),
            symbol = pair.symbol or "BTC/USDT",
            price_level = ctx.random.int(1, 100),
            queue_position = ctx.random.int(1, 50),
            validation_time_us = ctx.random.int(10, 100),
            risk_check_passed = true,
            available_balance = string.format("%.2f", ctx.random.float(10000, 1000000))
        }
    end
}
