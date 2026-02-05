-- Balance Transfer Generator
-- Generates log entries for balance transfers between accounts for settlement

return {
    metadata = {
        name = "settlement.balance_transfer",
        category = "SETTLEMENT",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Balance transferred between accounts for settlement",
        text_template = "[{timestamp}] TRANSFER: {transfer_id} {amount} {currency} from={from_account} to={to_account} type={transfer_type}",
        tags = {"settlement", "transfer", "balance"},
        merge_groups = {"settlements"}
    },

    generate = function(ctx, args)
        return {
            transfer_id = ctx.gen.uuid(),
            from_account = "acc_" .. ctx.random.int(100000, 999999),
            to_account = "acc_" .. ctx.random.int(100000, 999999),
            amount = string.format("%.5f", ctx.random.float(0.01, 100.0)),
            currency = ctx.random.choice({"BTC", "USDT", "ETH"}),
            transfer_type = ctx.random.choice({"TRADE_SETTLEMENT", "FEE_PAYMENT", "MARGIN_CALL"}),
            netting_batch_id = ctx.gen.uuid()
        }
    end
}
