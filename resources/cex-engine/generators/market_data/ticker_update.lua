-- Ticker Update Generator
-- Generates log entries for 24h ticker statistics updates

return {
    metadata = {
        name = "market_data.ticker_update",
        category = "MARKET_DATA",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "24h ticker statistics update",
        text_template = "[{timestamp}] TICKER: {symbol} last={last} volume_24h={volume_24h} change_24h={change_24h_pct}%",
        tags = {"market_data", "ticker", "statistics"},
        merge_groups = {"tickers"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        local last_price = ctx.random.float(30000, 60000)
        local change_pct = ctx.random.float(-15, 15)

        return {
            symbol = pair.symbol or "BTC/USDT",
            last = string.format("%.2f", last_price),
            bid = string.format("%.2f", last_price * 0.9995),
            ask = string.format("%.2f", last_price * 1.0005),
            high_24h = string.format("%.2f", last_price * 1.05),
            low_24h = string.format("%.2f", last_price * 0.95),
            volume_24h = string.format("%.2f", ctx.random.float(1000000, 50000000)),
            change_24h_pct = string.format("%.2f", change_pct),
            trades_24h = ctx.random.int(100000, 1000000)
        }
    end
}
