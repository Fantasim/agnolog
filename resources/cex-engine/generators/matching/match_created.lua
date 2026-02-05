-- Match Created Generator
-- Generates log entries when the matching engine creates a match between buyer and seller

return {
    metadata = {
        name = "matching.match_created",
        category = "MATCHING",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Matching engine created a match between buyer and seller",
        text_template = "[{timestamp}] MATCH: {match_id} {symbol} {quantity}@{price} buyer={buyer_order_id} seller={seller_order_id} latency={match_latency_us}us",
        tags = {"matching", "execution", "core"},
        merge_groups = {"matches"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        local base_price = ctx.random.float(20000, 70000)
        local quantity = ctx.random.float(0.001, 5.0)
        local match_latency = math.floor(ctx.random.gauss(50, 20))

        return {
            match_id = ctx.gen.uuid(),
            symbol = pair.symbol or "BTC/USDT",
            quantity = string.format("%.5f", quantity),
            price = string.format("%.2f", base_price),
            buyer_order_id = ctx.gen.uuid(),
            seller_order_id = ctx.gen.uuid(),
            match_latency_us = math.max(10, match_latency),
            match_time_ns = os.time() * 1000000000,
            aggressor_side = ctx.random.choice({"BUY", "SELL"}),
            match_algorithm = ctx.random.choice({"FIFO", "PRO_RATA"})
        }
    end
}
