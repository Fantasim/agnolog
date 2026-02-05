-- Candle Closed Generator
-- Generates log entries when candlestick intervals close

return {
    metadata = {
        name = "market_data.candle_closed",
        category = "MARKET_DATA",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Candlestick interval closed and published",
        text_template = "[{timestamp}] CANDLE: {symbol} {interval} O={open} H={high} L={low} C={close} V={volume}",
        tags = {"market_data", "candles", "ohlcv"},
        merge_groups = {"candles"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        local open = ctx.random.float(30000, 60000)
        local change = ctx.random.float(-0.02, 0.02)
        local close = open * (1 + change)
        local high = math.max(open, close) * (1 + ctx.random.float(0, 0.01))
        local low = math.min(open, close) * (1 - ctx.random.float(0, 0.01))

        return {
            symbol = pair.symbol or "BTC/USDT",
            interval = ctx.random.choice({"1m", "5m", "15m", "1h"}),
            open = string.format("%.2f", open),
            high = string.format("%.2f", high),
            low = string.format("%.2f", low),
            close = string.format("%.2f", close),
            volume = string.format("%.2f", ctx.random.float(100000, 5000000)),
            trades = ctx.random.int(1000, 50000)
        }
    end
}
