return {
    metadata = {
        name = "trading.order_filled",
        category = "TRADING",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Order has been filled completely or partially",
        text_template = "[{timestamp}] ORDER_FILLED: {order_id} {fill_type} {filled_qty}/{total_qty} {pair} @ {fill_price} (fee: {fee} {fee_currency})",
        tags = {"order", "trading", "execution", "fill"},
        merge_groups = {"orders"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}
        local is_partial = ctx.random.float(0, 1) < 0.3

        local total_qty = ctx.random.float(0.01, 2)
        local filled_qty = is_partial and (total_qty * ctx.random.float(0.3, 0.9)) or total_qty
        local fill_price = ctx.random.float(1000, 70000)
        local fee = fill_price * filled_qty * 0.001

        return {
            order_id = ctx.gen.uuid(),
            fill_type = is_partial and "PARTIAL" or "FULL",
            filled_qty = string.format("%.6f", filled_qty),
            total_qty = string.format("%.6f", total_qty),
            pair = ctx.random.choice(pairs),
            fill_price = string.format("%.2f", fill_price),
            fee = string.format("%.4f", fee),
            fee_currency = "USDT"
        }
    end
}
