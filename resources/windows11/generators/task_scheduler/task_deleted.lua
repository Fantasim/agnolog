-- Task Scheduler Event 141: Task deleted
-- Tracks task removal

return {
    metadata = {
        name = "task_scheduler.task_deleted",
        category = "TASK_SCHEDULER",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Task deleted",
        text_template = "[{timestamp}] Event {event_id}: Task Scheduler deleted task '{task_name}'",
        tags = {"task_scheduler", "configuration"},
        merge_groups = {"scheduled_tasks"}
    },

    generate = function(ctx, args)
        local task_names = {
            "\\CustomTasks\\OldBackup",
            "\\CustomTasks\\ObsoleteTask",
            "\\TemporaryTask",
            "\\ExpiredTask",
            "\\DeprecatedMaintenance"
        }

        local username = ctx.gen.windows_username()
        local domain = ctx.gen.windows_domain()

        return {
            event_id = 141,
            provider_name = "Microsoft-Windows-TaskScheduler",
            channel = "Microsoft-Windows-TaskScheduler/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "Task deleted",
            keywords = "0x8000000000000000",

            task_name = ctx.random.choice(task_names),
            user_context = string.format("%s\\%s", domain, username),

            description = "Task Scheduler deleted task"
        }
    end
}
