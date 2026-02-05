return {
    metadata = {
        name = "server.cpu_usage",
        category = "SERVER",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Server CPU usage metrics",
        text_template = "[{timestamp}] CPU: {cpu_percent}% usage on {server_id}",
        tags = {"server", "metrics", "cpu"},
        merge_groups = {"server_metrics"}
    },
    generate = function(ctx, args)
        local constants = ctx.data.constants.server.performance.cpu
        local cpu_percent = ctx.random.gauss(40, 15)
        cpu_percent = math.max(constants.idle[1], math.min(constants.critical[2], cpu_percent))

        return {
            server_id = ctx.random.choice({"game-server-01", "game-server-02", "game-server-03", "api-server-01"}),
            cpu_percent = math.floor(cpu_percent),
            cpu_cores = ctx.random.choice({8, 16, 32, 64}),
            load_1m = ctx.random.float(1, 10),
            load_5m = ctx.random.float(1, 8),
            load_15m = ctx.random.float(1, 6),
            active_games = ctx.random.int(100, 1000)
        }
    end
}
