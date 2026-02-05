return {
    metadata = {
        name = "trading.order_cancelled",
        category = "TRADING",
        severity = "WARNING",
        recurrence = "NORMAL",
        description = "Order has been cancelled",
        text_template = "[{timestamp}] ORDER_CANCELLED: {order_id} {pair} reason={reason}",
        tags = {"order", "trading", "cancel"},
        merge_groups = {"orders"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}
        local reasons = ctx.data.constants.cancel_reasons or {"user_requested", "timeout", "price_moved"}

        return {
            order_id = ctx.gen.uuid(),
            pair = ctx.random.choice(pairs),
            reason = ctx.random.choice(reasons)
        }
    end
}
