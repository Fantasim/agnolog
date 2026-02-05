-- Service Reload Generator
-- Generates service config reload log entries

return {
    metadata = {
        name = "service.reload",
        category = "SERVICE",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Service config reloaded",
        text_template = "[{timestamp}] systemd[1]: Reloaded {service_description}",
        tags = {"service", "systemd", "config"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local services = ctx.data.services.application_services.web_servers or {"nginx", "apache2"}
        local descriptions = ctx.data.services.system_daemons.service_descriptions or {}
        local service = ctx.random.choice(services)

        return {
            service = service,
            service_description = descriptions[service] or service
        }
    end
}
