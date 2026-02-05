return {
    metadata = {
        name = "trading.stop_loss_triggered",
        category = "TRADING",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Stop loss order triggered to limit losses",
        text_template = "[{timestamp}] STOP_LOSS: {position_id} {pair} triggered @ {trigger_price} loss={loss} ({loss_percent}%)",
        tags = {"position", "trading", "stop_loss", "risk"},
        merge_groups = {"positions"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}

        local pair = ctx.random.choice(pairs)
        local is_btc = string.find(pair, "BTC") ~= nil
        local entry_price = is_btc and ctx.random.float(40000, 70000) or ctx.random.float(1000, 4000)
        local loss_percent = ctx.random.float(1, 5)
        local trigger_price = entry_price * (1 - loss_percent / 100)
        local size = ctx.random.float(0.01, 1)
        local loss = (entry_price - trigger_price) * size

        return {
            position_id = ctx.gen.uuid(),
            pair = pair,
            trigger_price = string.format("%.2f", trigger_price),
            loss = string.format("-%.2f", loss),
            loss_percent = string.format("-%.2f", loss_percent)
        }
    end
}
