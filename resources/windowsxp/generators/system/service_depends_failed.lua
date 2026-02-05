-- System Service Depends Failed Generator (Event ID 7001)
-- Generates service depends on service which failed to start

return {
    metadata = {
        name = "system.service_depends_failed",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Service depends on service which failed to start",
        text_template = "Event Type: Error\nEvent Source: Service Control Manager\nEvent Category: None\nEvent ID: 7001\nComputer: {computer}\nDescription:\nThe {service_display_name} service depends on the {depends_on_service} service which failed to start because of the following error:\n{error_message}",
        tags = {"system", "service", "error", "dependency"},
        merge_groups = {"service_errors"}
    },

    generate = function(ctx, args)
        local services_data = ctx.data.system and ctx.data.system.services and ctx.data.system.services.services
        local services = services_data or {
            {name = "Spooler", display_name = "Print Spooler"},
            {name = "Browser", display_name = "Computer Browser"}
        }

        local service = ctx.random.choice(services)
        local depends_services = {"RpcSs", "lanmanserver", "Netlogon", "W32Time"}

        return {
            computer = ctx.gen.windows_computer(),
            service_name = service.name,
            service_display_name = service.display_name,
            depends_on_service = ctx.random.choice(depends_services),
            error_message = "The service did not start due to a logon failure."
        }
    end
}
