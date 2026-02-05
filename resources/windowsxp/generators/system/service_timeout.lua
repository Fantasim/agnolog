-- System Service Timeout Generator (Event ID 7011)
-- Generates service timeout

return {
    metadata = {
        name = "system.service_timeout",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Timeout waiting for service to respond",
        text_template = "Event Type: Error\nEvent Source: Service Control Manager\nEvent Category: None\nEvent ID: 7011\nComputer: {computer}\nDescription:\nTimeout ({timeout} milliseconds) waiting for a transaction response from the {service_display_name} service.",
        tags = {"system", "service", "timeout", "error"},
        merge_groups = {"service_errors"}
    },

    generate = function(ctx, args)
        local services_data = ctx.data.system and ctx.data.system.services and ctx.data.system.services.services
        local services = services_data or {
            {name = "DHCP", display_name = "DHCP Client"},
            {name = "Dnscache", display_name = "DNS Client"}
        }

        local service = ctx.random.choice(services)

        return {
            computer = ctx.gen.windows_computer(),
            service_name = service.name,
            service_display_name = service.display_name,
            timeout = ctx.random.choice({30000, 60000, 120000})
        }
    end
}
