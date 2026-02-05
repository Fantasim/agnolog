return {
    metadata = {
        name = "technical.api_request",
        category = "TECHNICAL",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "API request processed",
        text_template = "[{timestamp}] API: {method} {endpoint} - {status_code} ({response_time_ms}ms)",
        tags = {"technical", "api", "http"},
        merge_groups = {"api_requests"}
    },
    generate = function(ctx, args)
        local endpoints = ctx.data.constants.network.endpoints
        local methods = {"GET", "POST", "PUT", "DELETE", "PATCH"}
        local status_codes = {200, 200, 200, 201, 204, 400, 401, 404, 500}

        return {
            method = ctx.random.choice(methods),
            endpoint = ctx.random.choice(endpoints),
            status_code = ctx.random.choice(status_codes),
            response_time_ms = ctx.random.int(10, 500),
            user_id = ctx.gen.uuid(),
            ip_address = ctx.gen.ip_address(),
            user_agent = ctx.random.choice({"Chrome", "Firefox", "Safari", "Mobile App"}),
            request_size_bytes = ctx.random.int(100, 5000),
            response_size_bytes = ctx.random.int(500, 50000)
        }
    end
}
