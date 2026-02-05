-- Fee Collected Generator
-- Generates log entries when trading fees are collected from users

return {
    metadata = {
        name = "settlement.fee_collected",
        category = "SETTLEMENT",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Trading fee collected from user",
        text_template = "[{timestamp}] FEE: {trade_id} user={user_id} {fee_type} {fee_amount} {fee_currency} (rate={fee_rate})",
        tags = {"settlement", "fees", "revenue"},
        merge_groups = {"fee_collection"}
    },

    generate = function(ctx, args)
        local fee_rates = {
            MAKER = ctx.random.choice({-0.0001, 0.0004, 0.0006, 0.0008}),
            TAKER = ctx.random.choice({0.0006, 0.0008, 0.0010})
        }

        local fee_type = ctx.random.choice({"MAKER", "TAKER"})
        local notional = ctx.random.float(1000, 100000)
        local fee_rate = fee_rates[fee_type]
        local fee_amount = notional * math.abs(fee_rate)

        return {
            trade_id = ctx.gen.uuid(),
            user_id = "user_" .. ctx.random.int(10000, 99999),
            fee_type = fee_type,
            fee_amount = string.format("%.4f", fee_amount),
            fee_currency = "USDT",
            fee_rate = string.format("%.4f%%", fee_rate * 100),
            is_rebate = fee_rate < 0,
            fee_tier = ctx.random.choice({"VIP_0", "VIP_1", "VIP_2"})
        }
    end
}
