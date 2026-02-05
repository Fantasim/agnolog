return {
    metadata = {
        name = "trading.position_closed",
        category = "TRADING",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Trading position closed with profit/loss",
        text_template = "[{timestamp}] POSITION_CLOSED: {position_id} {pair} entry={entry_price} exit={exit_price} pnl={pnl} ({pnl_percent}%)",
        tags = {"position", "trading", "close", "pnl"},
        merge_groups = {"positions"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}

        local pair = ctx.random.choice(pairs)
        local is_btc = string.find(pair, "BTC") ~= nil
        local entry_price = is_btc and ctx.random.float(40000, 70000) or ctx.random.float(1000, 4000)
        local price_change = entry_price * ctx.random.float(-0.1, 0.15)
        local exit_price = entry_price + price_change
        local size = ctx.random.float(0.01, 1)
        local pnl = price_change * size
        local pnl_percent = (price_change / entry_price) * 100

        return {
            position_id = ctx.gen.uuid(),
            pair = pair,
            entry_price = string.format("%.2f", entry_price),
            exit_price = string.format("%.2f", exit_price),
            pnl = string.format("%+.2f", pnl),
            pnl_percent = string.format("%+.2f", pnl_percent)
        }
    end
}
