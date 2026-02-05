-- Nginx Start Generator
-- Generates Nginx start log entries

return {
    metadata = {
        name = "application.nginx_start",
        category = "APPLICATION",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Nginx started",
        text_template = "[{timestamp}] nginx[{pid}]: using the \"{event_method}\" event method",
        tags = {"nginx", "web"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local event_methods = {"epoll", "kqueue", "select", "poll"}

        return {
            pid = ctx.random.int(1000, 32768),
            event_method = ctx.random.choice(event_methods),
            worker_processes = ctx.random.int(1, 8)
        }
    end
}
