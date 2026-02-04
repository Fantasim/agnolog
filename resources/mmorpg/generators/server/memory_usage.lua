-- Server Memory Usage Generator

return {
    metadata = {
        name = "server.memory_usage",
        category = "SERVER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Memory usage metrics",
        text_template = "[{timestamp}] MEMORY: {used_mb}MB / {total_mb}MB ({percent}%)",
        tags = {"server", "performance", "memory"},
        merge_groups = {"server_metrics"}
    },

    generate = function(ctx, args)
        local typical_memory = 65
        local min_memory = 20
        local max_memory = 95

        if ctx.data.constants and ctx.data.constants.server then
            local sc = ctx.data.constants.server
            typical_memory = sc.typical_memory_percent or 65
            min_memory = sc.min_memory_percent or 20
            max_memory = sc.max_memory_percent or 95
        end

        local memory_sizes = {8192, 16384, 32768, 65536}
        local total_mb = ctx.random.choice(memory_sizes)

        local percent = ctx.random.gauss(typical_memory, 10)
        percent = math.max(min_memory, math.min(max_memory, percent))

        local used_mb = math.floor(total_mb * percent / 100)

        return {
            used_mb = used_mb,
            total_mb = total_mb,
            percent = math.floor(percent * 10) / 10,
            swap_used_mb = ctx.random.int(0, 1024),
            swap_total_mb = 2048
        }
    end
}
