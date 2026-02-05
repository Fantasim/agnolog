-- System Service Hang Generator (Event ID 7022)
-- Generates service hung on starting

return {
    metadata = {
        name = "system.service_hang",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Service hung on starting",
        text_template = "Event Type: Error\nEvent Source: Service Control Manager\nEvent Category: None\nEvent ID: 7022\nComputer: {computer}\nDescription:\nThe {service_display_name} service hung on starting.",
        tags = {"system", "service", "hang", "error"},
        merge_groups = {"service_errors"}
    },

    generate = function(ctx, args)
        local services_data = ctx.data.system and ctx.data.system.services and ctx.data.system.services.services
        local services = services_data or {
            {name = "Spooler", display_name = "Print Spooler"},
            {name = "wuauserv", display_name = "Automatic Updates"}
        }

        local service = ctx.random.choice(services)

        return {
            computer = ctx.gen.windows_computer(),
            service_name = service.name,
            service_display_name = service.display_name
        }
    end
}
