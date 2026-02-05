-- HTTP 4xx Error Generator
-- Generates HTTP 4xx error access log entries

return {
    metadata = {
        name = "application.http_error_4xx",
        category = "APPLICATION",
        severity = "WARNING",
        recurrence = "FREQUENT",
        description = "HTTP 4xx error",
        text_template = "{client_ip} - - [{timestamp_formatted}] \"{method} {path} {protocol}\" {status} {bytes} \"{referer}\" \"{user_agent}\"",
        tags = {"http", "web", "error"},
        merge_groups = {"http_access"}
    },

    generate = function(ctx, args)
        local methods = {"GET", "POST", "PUT", "DELETE"}
        local paths = {"/admin", "/wp-admin", "/.env", "/config.php", "/nonexistent", "/api/invalid"}
        local protocols = {"HTTP/1.1", "HTTP/2.0"}
        local status_codes = {400, 401, 403, 404, 405, 429}
        local user_agents = {
            "Mozilla/5.0 (compatible; Googlebot/2.1)",
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
            "curl/7.68.0"
        }

        return {
            client_ip = ctx.gen.ip_address(),
            timestamp_formatted = os.date("%d/%b/%Y:%H:%M:%S %z"),
            method = ctx.random.choice(methods),
            path = ctx.random.choice(paths),
            protocol = ctx.random.choice(protocols),
            status = ctx.random.choice(status_codes),
            bytes = ctx.random.int(100, 5000),
            referer = "-",
            user_agent = ctx.random.choice(user_agents)
        }
    end
}
