-- HTTP Request Generator
-- Generates HTTP request access log entries (Apache/Nginx format)

return {
    metadata = {
        name = "application.http_request",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "VERY_FREQUENT",
        description = "HTTP request",
        text_template = "{client_ip} - - [{timestamp_formatted}] \"{method} {path} {protocol}\" {status} {bytes} \"{referer}\" \"{user_agent}\"",
        tags = {"http", "web", "access"},
        merge_groups = {"http_access"}
    },

    generate = function(ctx, args)
        local methods = {"GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS"}
        local paths = {"/", "/index.html", "/api/users", "/api/products", "/login", "/logout", "/static/css/style.css", "/static/js/app.js", "/images/logo.png"}
        local protocols = {"HTTP/1.1", "HTTP/2.0"}
        local status_codes = {200, 200, 200, 200, 304, 301, 302}  -- mostly 200s
        local user_agents = {
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36",
            "curl/7.68.0",
            "python-requests/2.25.1"
        }

        return {
            client_ip = ctx.gen.ip_address(),
            timestamp_formatted = os.date("%d/%b/%Y:%H:%M:%S %z"),
            method = ctx.random.choice(methods),
            path = ctx.random.choice(paths),
            protocol = ctx.random.choice(protocols),
            status = ctx.random.choice(status_codes),
            bytes = ctx.random.int(200, 50000),
            referer = "-",
            user_agent = ctx.random.choice(user_agents)
        }
    end
}
