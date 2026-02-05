return {
    metadata = {
        name = "market.trend_change",
        category = "MARKET",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Market trend direction has changed",
        text_template = "[{timestamp}] TREND_CHANGE: {pair} {prev_trend} -> {new_trend} on {timeframe} confidence={confidence}%",
        tags = {"market", "trend", "analysis"},
        merge_groups = {"market_data"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}
        local trends = ctx.data.strategies.trend_directions or {"bullish", "bearish", "neutral"}
        local timeframes = ctx.data.constants.timeframes or {"1h", "4h", "1d"}

        local prev_trend = ctx.random.choice(trends)
        local new_trend = ctx.random.choice(trends)
        while new_trend == prev_trend do
            new_trend = ctx.random.choice(trends)
        end

        return {
            pair = ctx.random.choice(pairs),
            prev_trend = string.upper(prev_trend),
            new_trend = string.upper(new_trend),
            timeframe = ctx.random.choice(timeframes),
            confidence = ctx.random.int(65, 95)
        }
    end
}
