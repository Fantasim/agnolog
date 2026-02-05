-- Service Dependency Failed Generator
-- Generates service dependency failure log entries

return {
    metadata = {
        name = "service.dependency_failed",
        category = "SERVICE",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Service dependency failed",
        text_template = "[{timestamp}] systemd[1]: Dependency failed for {service}",
        tags = {"service", "systemd", "dependency"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local services = ctx.data.services.application_services.web_servers or {"nginx", "apache2"}

        return {
            service = ctx.random.choice(services),
            dependency = ctx.random.choice({"network.target", "mysql.service", "redis.service"})
        }
    end
}
