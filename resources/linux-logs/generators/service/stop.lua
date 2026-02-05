-- Service Stop Generator
-- Generates service stop log entries

return {
    metadata = {
        name = "service.stop",
        category = "SERVICE",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Service stopped",
        text_template = "[{timestamp}] systemd[1]: Stopped {service_description}",
        tags = {"service", "systemd"},
        merge_groups = {"service_state"}
    },

    generate = function(ctx, args)
        local services = ctx.data.services.system_daemons.core_services or {"sshd", "cron"}
        local descriptions = ctx.data.services.system_daemons.service_descriptions or {}
        local service = ctx.random.choice(services)

        return {
            service = service,
            service_description = descriptions[service] or service
        }
    end
}
