-- Order Book Update Generator
-- Generates log entries for order book state updates after matching cycles

return {
    metadata = {
        name = "matching.order_book_update",
        category = "MATCHING",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Order book state update after matching cycle",
        text_template = "[{timestamp}] BOOK_UPDATE: {symbol} bids={bid_levels} asks={ask_levels} spread={spread_bps}bps depth={total_depth}",
        tags = {"matching", "order_book", "market_structure"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        local best_bid = ctx.random.float(40000, 50000)
        local best_ask = best_bid * (1 + ctx.random.float(0.0001, 0.002))
        local spread_bps = math.floor((best_ask / best_bid - 1) * 10000)

        return {
            symbol = pair.symbol or "BTC/USDT",
            bid_levels = ctx.random.int(50, 500),
            ask_levels = ctx.random.int(50, 500),
            best_bid = string.format("%.2f", best_bid),
            best_ask = string.format("%.2f", best_ask),
            spread_bps = spread_bps,
            total_depth = string.format("%.2f", ctx.random.float(1000000, 50000000)),
            sequence_number = ctx.random.int(1000000, 9999999)
        }
    end
}
