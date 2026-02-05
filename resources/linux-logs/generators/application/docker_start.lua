-- Docker Start Generator
-- Generates Docker container start log entries

return {
    metadata = {
        name = "application.docker_start",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Docker container started",
        text_template = "[{timestamp}] dockerd[{pid}]: Container {container_id} started",
        tags = {"docker", "container"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local container_names = {
            "web", "db", "cache", "worker", "api",
            "nginx", "redis", "postgres", "app", "backend"
        }

        return {
            pid = ctx.random.int(1000, 32768),
            container_id = ctx.gen.hex_string(12),
            container_name = ctx.random.choice(container_names),
            image = ctx.random.choice(container_names) .. ":latest"
        }
    end
}
