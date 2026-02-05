-- Task Scheduler Event 140: Task updated
-- Tracks task configuration changes

return {
    metadata = {
        name = "task_scheduler.task_updated",
        category = "TASK_SCHEDULER",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "Task updated",
        text_template = "[{timestamp}] Event {event_id}: Task Scheduler updated task '{task_name}'",
        tags = {"task_scheduler", "configuration"},
        merge_groups = {"scheduled_tasks"}
    },

    generate = function(ctx, args)
        local task_names = {
            "\\Microsoft\\Windows\\UpdateOrchestrator\\Schedule Scan",
            "\\Microsoft\\Windows\\Defender\\Windows Defender Scheduled Scan",
            "\\CustomTasks\\Backup",
            "\\CustomTasks\\Maintenance",
            "\\MaintenanceTask"
        }

        local username = ctx.gen.windows_username()
        local domain = ctx.gen.windows_domain()

        return {
            event_id = 140,
            provider_name = "Microsoft-Windows-TaskScheduler",
            channel = "Microsoft-Windows-TaskScheduler/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "Task updated",
            keywords = "0x8000000000000000",

            task_name = ctx.random.choice(task_names),
            user_context = string.format("%s\\%s", domain, username),

            description = "Task Scheduler updated task"
        }
    end
}
