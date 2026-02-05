-- Throughput Metrics Generator
-- Generates log entries for system throughput and capacity metrics

return {
    metadata = {
        name = "system.throughput_metrics",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "System throughput and capacity metrics",
        text_template = "[{timestamp}] THROUGHPUT: orders_per_sec={orders_per_sec} matches_per_sec={matches_per_sec} capacity={capacity_pct}%",
        tags = {"system", "throughput", "capacity"},
        merge_groups = {"system_metrics"}
    },

    generate = function(ctx, args)
        local capacity_pct = ctx.random.float(20, 90)

        return {
            orders_per_sec = ctx.random.int(10000, 100000),
            matches_per_sec = ctx.random.int(5000, 50000),
            cancels_per_sec = ctx.random.int(2000, 20000),
            capacity_pct = string.format("%.2f", capacity_pct),
            queue_depth = ctx.random.int(0, 1000),
            dropped_messages = ctx.random.int(0, 10)
        }
    end
}
