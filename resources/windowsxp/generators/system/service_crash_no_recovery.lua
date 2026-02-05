-- System Service Crash No Recovery Generator (Event ID 7034)
-- Generates service terminated unexpectedly without recovery

return {
    metadata = {
        name = "system.service_crash_no_recovery",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Service terminated unexpectedly (no recovery)",
        text_template = "Event Type: Error\nEvent Source: Service Control Manager\nEvent Category: None\nEvent ID: 7034\nComputer: {computer}\nDescription:\nThe {service_display_name} service terminated unexpectedly. It has done this {crash_count} time(s).",
        tags = {"system", "service", "crash", "error"},
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
            crash_count = ctx.random.int(1, 3)
        }
    end
}
