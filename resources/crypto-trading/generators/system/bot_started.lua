return {
    metadata = {
        name = "system.bot_started",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "Trading bot has started",
        text_template = "[{timestamp}] BOT_STARTED: version={version} strategies={strategy_count} exchanges={exchange_count} pairs={pair_count}",
        tags = {"system", "lifecycle", "startup"},
        merge_groups = {"bot_lifecycle"}
    },

    generate = function(ctx, args)
        local strategies = ctx.data.strategies.strategy_types or {"grid_trading", "dca", "momentum"}
        local exchanges = ctx.data.exchanges.exchanges or {"Binance", "Coinbase Pro"}
        local pairs = ctx.data.cryptocurrencies.trading_pairs or {"BTC/USDT", "ETH/USDT"}

        return {
            version = string.format("%d.%d.%d", ctx.random.int(1, 3), ctx.random.int(0, 9), ctx.random.int(0, 20)),
            strategy_count = ctx.random.int(1, #strategies),
            exchange_count = ctx.random.int(1, math.min(3, #exchanges)),
            pair_count = ctx.random.int(3, math.min(10, #pairs))
        }
    end
}
