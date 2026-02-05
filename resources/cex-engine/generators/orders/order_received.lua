-- Order Received Generator
-- Generates log entries when an order is received by the gateway and queued for matching

return {
    metadata = {
        name = "orders.order_received",
        category = "ORDERS",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Order received by gateway and queued for matching",
        text_template = "[{timestamp}] ORDER_RECEIVED: {order_id} {side} {order_type} {quantity} {symbol} user={user_id} latency={gateway_latency_us}us",
        tags = {"orders", "gateway", "ingress"},
        merge_groups = {"order_lifecycle"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)
        local order_types = ctx.data.matching.order_types.order_types or {"LIMIT", "MARKET"}

        return {
            order_id = ctx.gen.uuid(),
            user_id = "user_" .. ctx.random.int(10000, 99999),
            account_type = ctx.random.choice({"RETAIL", "PROFESSIONAL", "MARKET_MAKER"}),
            symbol = pair.symbol or "BTC/USDT",
            side = ctx.random.choice({"BUY", "SELL"}),
            order_type = ctx.random.choice(order_types),
            quantity = string.format("%.5f", ctx.random.float(0.001, 10.0)),
            price = string.format("%.2f", ctx.random.float(30000, 60000)),
            gateway_latency_us = ctx.random.int(100, 5000),
            client_order_id = "client_" .. ctx.gen.uuid()
        }
    end
}
