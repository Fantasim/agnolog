-- Docker Stop Generator
-- Generates Docker container stop log entries

return {
    metadata = {
        name = "application.docker_stop",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Docker container stopped",
        text_template = "[{timestamp}] dockerd[{pid}]: Container {container_id} stopped with exit code {exit_code}",
        tags = {"docker", "container"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768),
            container_id = ctx.gen.hex_string(12),
            exit_code = ctx.random.choice({0, 0, 0, 1, 137, 143})  -- mostly 0
        }
    end
}
