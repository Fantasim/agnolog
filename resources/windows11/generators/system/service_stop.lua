-- System Event 7036: Service entered stopped state
-- Complements service start events

return {
    metadata = {
        name = "system.service_stop",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "A service entered the stopped state",
        text_template = "[{timestamp}] Event {event_id}: The {service_name} service entered the {state} state",
        tags = {"system", "service", "service_control"},
        merge_groups = {"service_state_changes"}
    },

    generate = function(ctx, args)
        -- Get services from YAML
        local services = ctx.data.system.services or {}
        local service = ctx.random.choice(services)

        -- Fallback if no services loaded
        if not service then
            service = {
                name = "UnknownService",
                display_name = "Unknown Service"
            }
        end

        return {
            event_id = 7036,
            provider_name = "Service Control Manager",
            channel = "System",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "None",
            keywords = "0x8080000000000000",  -- Classic

            service_name = service.display_name or service.name,
            service_internal_name = service.name,
            state = "stopped",

            description = string.format("The %s service entered the stopped state.", service.display_name or service.name)
        }
    end
}
