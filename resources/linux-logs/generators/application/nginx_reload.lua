-- Nginx Reload Generator
-- Generates Nginx config reload log entries

return {
    metadata = {
        name = "application.nginx_reload",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Nginx config reloaded",
        text_template = "[{timestamp}] nginx[{pid}]: signal process started, configuration reloaded",
        tags = {"nginx", "web", "config"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        return {
            pid = ctx.random.int(1000, 32768)
        }
    end
}
