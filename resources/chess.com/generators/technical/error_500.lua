return {
    metadata = {
        name = "technical.error_500",
        category = "TECHNICAL",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Internal server error (500)",
        text_template = "[{timestamp}] ERROR_500: {endpoint} - {error_type}",
        tags = {"technical", "error", "http"},
        merge_groups = {"errors"}
    },
    generate = function(ctx, args)
        local error_types = {
            "unhandled_exception",
            "null_pointer",
            "timeout",
            "resource_exhaustion",
            "dependency_failure",
            "configuration_error"
        }

        local endpoints = {"/api/game/start", "/api/game/move", "/api/matchmaking/queue", "/api/user/profile"}

        return {
            endpoint = ctx.random.choice(endpoints),
            error_type = ctx.random.choice(error_types),
            stack_trace_lines = ctx.random.int(10, 50),
            user_id = ctx.gen.uuid(),
            request_id = ctx.gen.uuid(),
            error_logged = true,
            alert_sent = ctx.random.float(0, 1) < 0.7
        }
    end
}
