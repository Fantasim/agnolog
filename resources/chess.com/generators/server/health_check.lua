return {
    metadata = {
        name = "server.health_check",
        category = "SERVER",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Server health check",
        text_template = "[{timestamp}] HEALTH_CHECK: {server_id} - {status}",
        tags = {"server", "health", "monitoring"},
        merge_groups = {"server_metrics"}
    },
    generate = function(ctx, args)
        local healthy = ctx.random.float(0, 1) < 0.98

        return {
            server_id = ctx.random.choice({"game-server-01", "game-server-02", "game-server-03", "api-server-01"}),
            status = healthy and "healthy" or "degraded",
            response_time_ms = ctx.random.int(1, 100),
            checks_passed = healthy and ctx.random.int(8, 10) or ctx.random.int(5, 9),
            checks_total = 10,
            services_up = ctx.random.int(8, 12),
            services_total = 12
        }
    end
}
