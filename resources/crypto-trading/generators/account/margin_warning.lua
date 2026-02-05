return {
    metadata = {
        name = "account.margin_warning",
        category = "ACCOUNT",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Account margin level is low",
        text_template = "[{timestamp}] MARGIN_WARNING: {exchange} margin_level={margin_level}% (min={min_margin}%) equity={equity} USDT",
        tags = {"account", "margin", "risk", "alert"},
        merge_groups = {"account_balance"}
    },

    generate = function(ctx, args)
        local exchanges = ctx.data.exchanges.exchanges or {"Binance", "Coinbase Pro"}

        local min_margin = ctx.random.int(20, 30)
        local margin_level = min_margin + ctx.random.float(1, 10)
        local equity = ctx.random.float(5000, 50000)

        return {
            exchange = ctx.random.choice(exchanges),
            margin_level = string.format("%.1f", margin_level),
            min_margin = min_margin,
            equity = string.format("%.2f", equity)
        }
    end
}
