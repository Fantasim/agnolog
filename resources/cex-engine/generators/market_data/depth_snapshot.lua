-- Depth Snapshot Generator
-- Generates log entries for order book depth snapshots

return {
    metadata = {
        name = "market_data.depth_snapshot",
        category = "MARKET_DATA",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Order book depth snapshot published",
        text_template = "[{timestamp}] DEPTH: {symbol} snapshot_id={snapshot_id} levels={total_levels} depth={total_depth}",
        tags = {"market_data", "depth", "order_book"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        return {
            symbol = pair.symbol or "BTC/USDT",
            snapshot_id = ctx.random.int(1000000, 9999999),
            bid_levels = ctx.random.int(50, 500),
            ask_levels = ctx.random.int(50, 500),
            total_levels = ctx.random.int(100, 1000),
            total_depth = string.format("%.2f", ctx.random.float(5000000, 100000000)),
            compression_ratio = string.format("%.2f", ctx.random.float(1.5, 5.0)),
            publish_latency_us = ctx.random.int(100, 1000)
        }
    end
}
