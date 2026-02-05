-- System Service Control Sent Generator (Event ID 7035)
-- Generates service sent a control

return {
    metadata = {
        name = "system.service_control_sent",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Service sent a control",
        text_template = "Event Type: Information\nEvent Source: Service Control Manager\nEvent Category: None\nEvent ID: 7035\nComputer: {computer}\nDescription:\nThe {service_display_name} service was successfully sent a {control} control.",
        tags = {"system", "service", "control"},
        merge_groups = {"service_state"}
    },

    generate = function(ctx, args)
        local services_data = ctx.data.system and ctx.data.system.services and ctx.data.system.services.services
        local services = services_data or {
            {name = "W32Time", display_name = "Windows Time"},
            {name = "DHCP", display_name = "DHCP Client"}
        }

        local service = ctx.random.choice(services)
        local controls = {"stop", "start", "pause", "continue", "interrogate"}

        return {
            computer = ctx.gen.windows_computer(),
            service_name = service.name,
            service_display_name = service.display_name,
            control = ctx.random.choice(controls)
        }
    end
}
