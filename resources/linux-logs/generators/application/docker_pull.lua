-- Docker Pull Generator
-- Generates Docker image pull log entries

return {
    metadata = {
        name = "application.docker_pull",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Docker image pulled",
        text_template = "[{timestamp}] dockerd[{pid}]: Pulling image {image}:{tag}",
        tags = {"docker", "image"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local images = {"nginx", "redis", "postgres", "mysql", "node", "python", "ubuntu", "alpine"}
        local tags = {"latest", "stable", "1.0", "2.0", "alpine"}

        return {
            pid = ctx.random.int(1000, 32768),
            image = ctx.random.choice(images),
            tag = ctx.random.choice(tags),
            size_mb = ctx.random.int(10, 500)
        }
    end
}
