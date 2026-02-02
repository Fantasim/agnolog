-- Server CPU Usage Generator

return {
    metadata = {
        name = "server.cpu_usage",
        category = "SERVER",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "CPU usage metrics",
        text_template = "[{timestamp}] CPU: {cpu_percent}% (avg: {cpu_avg}%, cores: {cpu_cores})",
        tags = {"server", "performance", "cpu"}
    },

    generate = function(ctx, args)
        local typical_cpu = 45
        local min_cpu = 5
        local max_cpu = 95

        if ctx.data.constants and ctx.data.constants.server then
            local sc = ctx.data.constants.server
            typical_cpu = sc.typical_cpu_percent or 45
            min_cpu = sc.min_cpu_percent or 5
            max_cpu = sc.max_cpu_percent or 95
        end

        -- Weighted toward typical usage
        local cpu = ctx.random.gauss(typical_cpu, 15)
        cpu = math.max(min_cpu, math.min(max_cpu, cpu))

        local cpu_avg = ctx.random.gauss(typical_cpu, 10)
        cpu_avg = math.max(min_cpu, math.min(max_cpu, cpu_avg))

        local cores = {4, 8, 16, 32, 64}

        return {
            cpu_percent = math.floor(cpu * 10) / 10,
            cpu_avg = math.floor(cpu_avg * 10) / 10,
            cpu_cores = ctx.random.choice(cores),
            load_1m = math.floor(ctx.random.float() * 350 + 50) / 100,
            load_5m = math.floor(ctx.random.float() * 300 + 50) / 100,
            load_15m = math.floor(ctx.random.float() * 250 + 50) / 100
        }
    end
}
