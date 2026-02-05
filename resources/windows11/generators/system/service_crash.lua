-- System Event 7034: A service terminated unexpectedly
-- Important for detecting service failures

return {
    metadata = {
        name = "system.service_crash",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "A service terminated unexpectedly",
        text_template = "[{timestamp}] Event {event_id}: The {service_name} service terminated unexpectedly. It has done this {crash_count} time(s)",
        tags = {"system", "service", "crash", "error"},
        merge_groups = {"service_failures"}
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

        -- Crash count (weighted towards 1)
        local crash_count = ctx.random.weighted_choice({1, 2, 3, 4, 5}, {0.6, 0.2, 0.1, 0.05, 0.05})

        return {
            event_id = 7034,
            provider_name = "Service Control Manager",
            channel = "System",
            computer = ctx.gen.windows_computer(),
            level = "Error",
            task_category = "None",
            keywords = "0x80000000000000",  -- Classic

            service_name = service.display_name or service.name,
            service_internal_name = service.name,
            crash_count = crash_count,

            description = string.format("The %s service terminated unexpectedly. It has done this %d time(s).",
                service.display_name or service.name, crash_count)
        }
    end
}
