-- Circuit Breaker Triggered Generator
-- Generates log entries when circuit breaker is triggered due to extreme price movement

return {
    metadata = {
        name = "system.circuit_breaker_triggered",
        category = "SYSTEM",
        severity = "CRITICAL",
        recurrence = "RARE",
        description = "Circuit breaker triggered due to extreme price movement",
        text_template = "[{timestamp}] CIRCUIT_BREAKER: {symbol} triggered at {trigger_price} change={price_change_pct}% cooldown={cooldown_seconds}s",
        tags = {"system", "circuit_breaker", "market_protection"},
        merge_groups = {"system_events"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        local reference_price = ctx.random.float(30000, 60000)
        local price_change = ctx.random.choice({-15, -10, 10, 15})
        local trigger_price = reference_price * (1 + price_change / 100)

        return {
            symbol = pair.symbol or "BTC/USDT",
            trigger_price = string.format("%.2f", trigger_price),
            reference_price = string.format("%.2f", reference_price),
            price_change_pct = string.format("%.2f", price_change),
            cooldown_seconds = ctx.random.choice({60, 300, 600}),
            trading_halted = true
        }
    end
}
