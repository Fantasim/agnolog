return {
    metadata = {
        name = "system.strategy_loaded",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "Trading strategy has been loaded and activated",
        text_template = "[{timestamp}] STRATEGY_LOADED: {strategy} for {pair} on {exchange} timeframe={timeframe}",
        tags = {"system", "strategy", "config"},
        merge_groups = {"bot_lifecycle"}
    },

    generate = function(ctx, args)
        local strategies = ctx.data.strategies.strategy_types or {"grid_trading", "dca", "momentum"}
        local exchanges = ctx.data.exchanges.exchanges or {"Binance", "Coinbase Pro"}
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}
        local timeframes = ctx.data.constants.timeframes or {"1h", "4h", "1d"}

        return {
            strategy = ctx.random.choice(strategies),
            pair = ctx.random.choice(pairs),
            exchange = ctx.random.choice(exchanges),
            timeframe = ctx.random.choice(timeframes)
        }
    end
}
