return {
    metadata = {
        name = "system.exchange_connected",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "Bot successfully connected to exchange",
        text_template = "[{timestamp}] EXCHANGE_CONNECTED: {exchange} latency={latency}ms api_version={api_version}",
        tags = {"system", "exchange", "connection"},
        merge_groups = {"bot_lifecycle"}
    },

    generate = function(ctx, args)
        local exchanges = ctx.data.exchanges.exchanges or {"Binance", "Coinbase Pro"}

        return {
            exchange = ctx.random.choice(exchanges),
            latency = ctx.random.int(10, 150),
            api_version = string.format("v%d", ctx.random.int(2, 4))
        }
    end
}
