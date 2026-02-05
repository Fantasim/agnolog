return {
    metadata = {
        name = "server.maintenance_end",
        category = "SERVER",
        severity = "INFO",
        recurrence = "RARE",
        description = "Server maintenance completed",
        text_template = "[{timestamp}] MAINTENANCE_END: {server_id} back online after {actual_duration_minutes}min",
        tags = {"server", "maintenance"},
        merge_groups = {"server_events"}
    },
    generate = function(ctx, args)
        return {
            server_id = ctx.random.choice({"game-server-01", "game-server-02", "api-server-01", "db-server-01"}),
            actual_duration_minutes = ctx.random.int(25, 200),
            estimated_duration_minutes = ctx.random.int(30, 180),
            health_check_passed = ctx.random.float(0, 1) < 0.95,
            services_restored = ctx.random.int(10, 20)
        }
    end
}
