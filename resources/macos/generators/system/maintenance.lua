-- System Maintenance Generator
-- Generates periodic maintenance task log entries

return {
    metadata = {
        name = "system.maintenance",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Periodic maintenance task executed",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Running {task_type} maintenance task",
        tags = {"system", "maintenance", "periodic"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local task_types = {
            "daily", "weekly", "monthly"
        }

        local tasks = {
            "log rotation",
            "cache cleanup",
            "temporary file cleanup",
            "database optimization",
            "index rebuild",
            "backup verification"
        }

        return {
            process = "periodic",
            pid = ctx.random.int(1000, 65535),
            level = "Default",
            subsystem = "com.apple.periodic",
            category = "maintenance",
            task_type = ctx.random.choice(task_types),
            task_name = ctx.random.choice(tasks),
            duration_sec = ctx.random.int(1, 300),
            files_processed = ctx.random.int(10, 10000)
        }
    end
}
