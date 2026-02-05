-- System Service Start Generator (Event ID 7036)
-- Generates service entered running state events (VERY FREQUENT)

return {
    metadata = {
        name = "system.service_start",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "Service entered the running state",
        text_template = "Event Type: Information\nEvent Source: Service Control Manager\nEvent Category: None\nEvent ID: 7036\nComputer: {computer}\nDescription:\nThe {service_display_name} service entered the running state.",
        tags = {"system", "service", "scm"},
        merge_groups = {"service_state"}
    },

    generate = function(ctx, args)
        local services_data = ctx.data.system and ctx.data.system.services and ctx.data.system.services.services
        local services = services_data or {
            {name = "EventLog", display_name = "Event Log"},
            {name = "W32Time", display_name = "Windows Time"},
            {name = "DHCP", display_name = "DHCP Client"}
        }

        local service = ctx.random.choice(services)

        return {
            computer = ctx.gen.windows_computer(),
            service_name = service.name,
            service_display_name = service.display_name
        }
    end
}
