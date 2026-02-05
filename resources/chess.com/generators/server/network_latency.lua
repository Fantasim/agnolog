return {
    metadata = {
        name = "server.network_latency",
        category = "SERVER",
        severity = "DEBUG",
        recurrence = "FREQUENT",
        description = "Network latency measurements",
        text_template = "[{timestamp}] LATENCY: {region} avg {avg_latency_ms}ms (p95: {p95_latency_ms}ms)",
        tags = {"server", "metrics", "network", "latency"},
        merge_groups = {"server_metrics"}
    },
    generate = function(ctx, args)
        local regions = ctx.data.constants.server.regions
        local region = ctx.random.choice(regions)

        return {
            region = region.code,
            region_name = region.name,
            avg_latency_ms = ctx.random.int(20, 150),
            p50_latency_ms = ctx.random.int(15, 100),
            p95_latency_ms = ctx.random.int(50, 300),
            p99_latency_ms = ctx.random.int(100, 500),
            packet_loss_percent = ctx.random.float(0, 2)
        }
    end
}
