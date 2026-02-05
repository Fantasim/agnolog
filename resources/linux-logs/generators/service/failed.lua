-- Service Failed Generator
-- Generates service failure log entries

return {
    metadata = {
        name = "service.failed",
        category = "SERVICE",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Service failed to start",
        text_template = "[{timestamp}] systemd[1]: {service}.service: Failed with result '{result}'",
        tags = {"service", "systemd", "error"},
        merge_groups = {"service_state"}
    },

    generate = function(ctx, args)
        local services = ctx.data.services.application_services.web_servers or {"nginx", "apache2"}
        local results = {"exit-code", "timeout", "signal", "core-dump", "resources"}

        return {
            service = ctx.random.choice(services),
            result = ctx.random.choice(results),
            exit_code = ctx.random.int(1, 255)
        }
    end
}
