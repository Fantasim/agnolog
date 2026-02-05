-- System Service Start Failed Generator (Event ID 7000)
-- Generates service failed to start events

return {
    metadata = {
        name = "system.service_start_failed",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Service failed to start",
        text_template = "Event Type: Error\nEvent Source: Service Control Manager\nEvent Category: None\nEvent ID: 7000\nComputer: {computer}\nDescription:\nThe {service_display_name} service failed to start due to the following error:\n{error_message}",
        tags = {"system", "service", "error", "scm"},
        merge_groups = {"service_errors"}
    },

    generate = function(ctx, args)
        local services_data = ctx.data.system and ctx.data.system.services and ctx.data.system.services.services
        local services = services_data or {
            {name = "DHCP", display_name = "DHCP Client"},
            {name = "Spooler", display_name = "Print Spooler"}
        }

        local service = ctx.random.choice(services)

        local error_messages = {
            "The service did not respond to the start or control request in a timely fashion.",
            "The service cannot be started, either because it is disabled or because it has no enabled devices associated with it.",
            "The system cannot find the file specified.",
            "The service depends on a service that failed to start.",
            "A system shutdown is in progress.",
            "Access is denied."
        }

        return {
            computer = ctx.gen.windows_computer(),
            service_name = service.name,
            service_display_name = service.display_name,
            error_message = ctx.random.choice(error_messages),
            error_code = ctx.random.choice({"0x80070005", "0x8007042C", "0x80070002", "0x8007041D"})
        }
    end
}
