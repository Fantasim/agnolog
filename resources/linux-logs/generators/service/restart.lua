-- Service Restart Generator
-- Generates service restart log entries

return {
    metadata = {
        name = "service.restart",
        category = "SERVICE",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Service restarted",
        text_template = "[{timestamp}] systemd[1]: Restarting {service_description}",
        tags = {"service", "systemd"},
        merge_groups = {"service_state"}
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
