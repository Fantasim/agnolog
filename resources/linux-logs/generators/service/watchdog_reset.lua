-- Service Watchdog Reset Generator
-- Generates service watchdog reset log entries

return {
    metadata = {
        name = "service.watchdog_reset",
        category = "SERVICE",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Service watchdog reset",
        text_template = "[{timestamp}] systemd[1]: {service}.service: Watchdog timeout (limit {timeout}s)!",
        tags = {"service", "systemd", "watchdog"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local services = ctx.data.services.application_services.database_servers or {"mysqld", "postgres"}

        return {
            service = ctx.random.choice(services),
            timeout = ctx.random.int(30, 300)
        }
    end
}
