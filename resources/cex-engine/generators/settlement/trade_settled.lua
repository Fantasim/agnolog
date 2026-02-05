-- Trade Settled Generator
-- Generates log entries when a trade is successfully settled and balances updated

return {
    metadata = {
        name = "settlement.trade_settled",
        category = "SETTLEMENT",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Trade successfully settled and balances updated",
        text_template = "[{timestamp}] SETTLEMENT: trade_id={trade_id} {symbol} buyer={buyer_account} seller={seller_account} amount={notional_value}",
        tags = {"settlement", "clearing", "balance_update"},
        merge_groups = {"settlements"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        local quantity = ctx.random.float(0.01, 5.0)
        local price = ctx.random.float(30000, 60000)
        local notional = quantity * price

        return {
            trade_id = ctx.gen.uuid(),
            match_id = ctx.gen.uuid(),
            symbol = pair.symbol or "BTC/USDT",
            buyer_account = "acc_" .. ctx.random.int(100000, 999999),
            seller_account = "acc_" .. ctx.random.int(100000, 999999),
            quantity = string.format("%.5f", quantity),
            price = string.format("%.2f", price),
            notional_value = string.format("%.2f", notional),
            settlement_cycle = "T+0",
            settlement_time_ms = ctx.random.int(100, 2000)
        }
    end
}
