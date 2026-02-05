-- Service Start Generator
-- Generates service start log entries

return {
    metadata = {
        name = "service.start",
        category = "SERVICE",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Service started",
        text_template = "[{timestamp}] systemd[1]: Started {service_description}",
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
