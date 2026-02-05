-- Service Timeout Generator
-- Generates service start timeout log entries

return {
    metadata = {
        name = "service.timeout",
        category = "SERVICE",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Service start timeout",
        text_template = "[{timestamp}] systemd[1]: {service}.service: Start operation timed out. Terminating",
        tags = {"service", "systemd", "timeout"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local services = ctx.data.services.application_services.database_servers or {"mysqld", "postgres"}

        return {
            service = ctx.random.choice(services),
            timeout_seconds = ctx.random.int(90, 600)
        }
    end
}
