-- System Service Crash Generator (Event ID 7031)
-- Generates service terminated unexpectedly events

return {
    metadata = {
        name = "system.service_crash",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Service terminated unexpectedly",
        text_template = "Event Type: Error\nEvent Source: Service Control Manager\nEvent Category: None\nEvent ID: 7031\nComputer: {computer}\nDescription:\nThe {service_display_name} service terminated unexpectedly. It has done this {crash_count} time(s). The following corrective action will be taken in {restart_delay} milliseconds: {recovery_action}.",
        tags = {"system", "service", "crash", "error"},
        merge_groups = {"service_errors"}
    },

    generate = function(ctx, args)
        local services_data = ctx.data.system and ctx.data.system.services and ctx.data.system.services.services
        local services = services_data or {
            {name = "DHCP", display_name = "DHCP Client"},
            {name = "Dnscache", display_name = "DNS Client"},
            {name = "Spooler", display_name = "Print Spooler"}
        }

        local service = ctx.random.choice(services)

        local recovery_actions = {
            "Restart the service",
            "Run a program",
            "Restart the computer",
            "No action"
        }

        return {
            computer = ctx.gen.windows_computer(),
            service_name = service.name,
            service_display_name = service.display_name,
            crash_count = ctx.random.int(1, 3),
            restart_delay = ctx.random.choice({60000, 120000, 300000}),
            recovery_action = ctx.random.choice(recovery_actions)
        }
    end
}
