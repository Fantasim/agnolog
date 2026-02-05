-- Liquidation Completed Generator
-- Generates log entries when forced liquidation is completed

return {
    metadata = {
        name = "risk.liquidation_completed",
        category = "RISK",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Forced liquidation completed",
        text_template = "[{timestamp}] LIQUIDATION_COMPLETE: {liquidation_id} executed={executed_qty} avg_price={avg_price} loss={realized_loss} fee={liquidation_fee}",
        tags = {"risk", "liquidation", "loss"},
        merge_groups = {"liquidations"}
    },

    generate = function(ctx, args)
        local executed_qty = ctx.random.float(0.1, 10.0)
        local avg_price = ctx.random.float(30000, 60000)
        local notional = executed_qty * avg_price
        local realized_loss = notional * ctx.random.float(0.05, 0.30)
        local liquidation_fee = notional * 0.005

        return {
            liquidation_id = ctx.gen.uuid(),
            user_id = "user_" .. ctx.random.int(10000, 99999),
            symbol = "BTC/USDT",
            executed_qty = string.format("%.5f", executed_qty),
            avg_price = string.format("%.2f", avg_price),
            realized_loss = string.format("%.2f", realized_loss),
            liquidation_fee = string.format("%.2f", liquidation_fee),
            fills_count = ctx.random.int(1, 20),
            duration_ms = ctx.random.int(100, 30000)
        }
    end
}
