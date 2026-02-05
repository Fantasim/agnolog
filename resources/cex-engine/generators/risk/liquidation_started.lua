-- Liquidation Started Generator
-- Generates log entries when forced liquidation process is initiated

return {
    metadata = {
        name = "risk.liquidation_started",
        category = "RISK",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Forced liquidation process started",
        text_template = "[{timestamp}] LIQUIDATION: user={user_id} {symbol} position={position_size} mark_price={mark_price} margin_ratio={margin_ratio}%",
        tags = {"risk", "liquidation", "forced_close"},
        merge_groups = {"liquidations"}
    },

    generate = function(ctx, args)
        local pairs = ctx.data.instruments.trading_pairs.majors or {}
        local pair = ctx.random.choice(pairs)

        return {
            user_id = "user_" .. ctx.random.int(10000, 99999),
            symbol = pair.symbol or "BTC/USDT",
            position_size = string.format("%.5f", ctx.random.float(0.1, 10.0)),
            mark_price = string.format("%.2f", ctx.random.float(30000, 60000)),
            margin_ratio = string.format("%.2f", ctx.random.float(0.1, 2.5)),
            liquidation_price = string.format("%.2f", ctx.random.float(30000, 60000)),
            liquidation_id = ctx.gen.uuid()
        }
    end
}
