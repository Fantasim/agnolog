return {
    metadata = {
        name = "market.signal_detected",
        category = "MARKET",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Trading signal detected by strategy",
        text_template = "[{timestamp}] SIGNAL: {signal_type} on {pair} timeframe={timeframe} strength={strength}% action={action}",
        tags = {"market", "signal", "strategy", "analysis"},
        merge_groups = {"market_data"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}
        local signals = ctx.data.strategies.signal_types or {"golden_cross", "rsi_oversold", "macd_crossover"}
        local timeframes = ctx.data.constants.timeframes or {"1h", "4h", "1d"}

        local signal = ctx.random.choice(signals)
        local is_bullish = string.find(signal, "oversold") or string.find(signal, "golden") or string.find(signal, "bounce")

        return {
            signal_type = signal,
            pair = ctx.random.choice(pairs),
            timeframe = ctx.random.choice(timeframes),
            strength = ctx.random.int(60, 95),
            action = is_bullish and "BUY" or "SELL"
        }
    end
}
