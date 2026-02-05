-- Netting Cycle Generator
-- Generates log entries for multilateral netting cycle completion

return {
    metadata = {
        name = "settlement.netting_cycle",
        category = "SETTLEMENT",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Multilateral netting cycle completed",
        text_template = "[{timestamp}] NETTING: batch_id={batch_id} participants={participant_count} gross={gross_value} net={net_value} reduction={reduction_pct}%",
        tags = {"settlement", "netting", "clearing"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local gross_value = ctx.random.float(1000000, 100000000)
        local reduction_pct = ctx.random.float(60, 95)
        local net_value = gross_value * (1 - reduction_pct / 100)

        return {
            batch_id = ctx.gen.uuid(),
            participant_count = ctx.random.int(50, 500),
            trade_count = ctx.random.int(1000, 50000),
            gross_value = string.format("%.2f", gross_value),
            net_value = string.format("%.2f", net_value),
            reduction_pct = string.format("%.2f", reduction_pct),
            cycle_time_ms = ctx.random.int(500, 5000)
        }
    end
}
