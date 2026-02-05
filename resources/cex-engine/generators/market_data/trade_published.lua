-- Trade Published Generator
-- Generates log entries for trades published to market data feed

return {
    metadata = {
        name = "market_data.trade_published",
        category = "MARKET_DATA",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Trade published to market data feed",
        text_template = "[{timestamp}] TRADE: {trade_id} {symbol} {quantity}@{price} aggressor={aggressor_side}",
        tags = {"market_data", "trade", "public_feed"},
        merge_groups = {"public_trades"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        return {
            trade_id = ctx.gen.uuid(),
            symbol = pair.symbol or "BTC/USDT",
            price = string.format("%.2f", ctx.random.float(30000, 60000)),
            quantity = string.format("%.5f", ctx.random.float(0.001, 5.0)),
            aggressor_side = ctx.random.choice({"BUY", "SELL"}),
            sequence_number = ctx.random.int(1000000, 9999999),
            publish_latency_us = ctx.random.int(50, 500)
        }
    end
}
