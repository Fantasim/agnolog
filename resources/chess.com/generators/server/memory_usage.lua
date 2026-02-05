return {
    metadata = {
        name = "server.memory_usage",
        category = "SERVER",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Server memory usage metrics",
        text_template = "[{timestamp}] MEMORY: {memory_percent}% ({memory_used_gb}GB / {memory_total_gb}GB) on {server_id}",
        tags = {"server", "metrics", "memory"},
        merge_groups = {"server_metrics"}
    },
    generate = function(ctx, args)
        local memory_total_gb = ctx.random.choice({32, 64, 128, 256})
        local memory_percent = ctx.random.gauss(55, 15)
        memory_percent = math.max(10, math.min(95, memory_percent))
        local memory_used_gb = (memory_total_gb * memory_percent) / 100

        return {
            server_id = ctx.random.choice({"game-server-01", "game-server-02", "game-server-03", "api-server-01"}),
            memory_percent = math.floor(memory_percent),
            memory_used_gb = math.floor(memory_used_gb * 10) / 10,
            memory_total_gb = memory_total_gb,
            swap_used_mb = ctx.random.int(0, 2048)
        }
    end
}
