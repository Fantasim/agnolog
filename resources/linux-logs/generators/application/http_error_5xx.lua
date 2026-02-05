-- HTTP 5xx Error Generator
-- Generates HTTP 5xx error access log entries

return {
    metadata = {
        name = "application.http_error_5xx",
        category = "APPLICATION",
        severity = "ERROR",
        recurrence = "NORMAL",
        description = "HTTP 5xx error",
        text_template = "{client_ip} - - [{timestamp_formatted}] \"{method} {path} {protocol}\" {status} {bytes}",
        tags = {"http", "web", "error"},
        merge_groups = {"http_access"}
    },

    generate = function(ctx, args)
        local methods = {"GET", "POST"}
        local paths = {"/api/data", "/api/process", "/cgi-bin/script", "/app/generate"}
        local status_codes = {500, 502, 503, 504}

        return {
            client_ip = ctx.gen.ip_address(),
            timestamp_formatted = os.date("%d/%b/%Y:%H:%M:%S %z"),
            method = ctx.random.choice(methods),
            path = ctx.random.choice(paths),
            protocol = "HTTP/1.1",
            status = ctx.random.choice(status_codes),
            bytes = ctx.random.int(200, 2000)
        }
    end
}
