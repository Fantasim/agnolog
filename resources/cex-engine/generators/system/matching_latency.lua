-- Matching Latency Generator
-- Generates log entries for matching engine latency metrics

return {
    metadata = {
        name = "system.matching_latency",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Matching engine latency metrics",
        text_template = "[{timestamp}] LATENCY: engine={engine_id} p50={p50_us}us p99={p99_us}us max={max_us}us throughput={throughput_ops}",
        tags = {"system", "performance", "metrics"},
        merge_groups = {"system_metrics"}
    },

    generate = function(ctx, args)
        local p50 = math.floor(ctx.random.gauss(50, 10))
        local p99 = math.floor(ctx.random.gauss(200, 50))
        local max = ctx.random.int(300, 1000)

        return {
            engine_id = "engine_" .. ctx.random.int(1, 8),
            p50_us = math.max(10, p50),
            p95_us = math.max(p50, math.floor(ctx.random.gauss(150, 30))),
            p99_us = math.max(p50, p99),
            max_us = max,
            throughput_ops = ctx.random.int(50000, 150000),
            measurement_window_ms = 1000
        }
    end
}
