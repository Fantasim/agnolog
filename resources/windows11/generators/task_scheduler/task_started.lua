-- Task Scheduler Event 100: Task started
-- Tracks task execution start

return {
    metadata = {
        name = "task_scheduler.task_started",
        category = "TASK_SCHEDULER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Task started",
        text_template = "[{timestamp}] Event {event_id}: Task Scheduler successfully started '{task_name}' instance",
        tags = {"task_scheduler", "execution"},
        merge_groups = {"scheduled_tasks"}
    },

    generate = function(ctx, args)
        local task_names = {
            "\\Microsoft\\Windows\\UpdateOrchestrator\\Schedule Scan",
            "\\Microsoft\\Windows\\Defender\\Windows Defender Scheduled Scan",
            "\\Microsoft\\Windows\\WindowsUpdate\\Scheduled Start",
            "\\CustomTasks\\Backup",
            "\\CustomTasks\\Maintenance",
            "\\MaintenanceTask",
            "\\DailyCleanup"
        }

        return {
            event_id = 100,
            provider_name = "Microsoft-Windows-TaskScheduler",
            channel = "Microsoft-Windows-TaskScheduler/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "Task started",
            keywords = "0x8000000000000000",

            task_name = ctx.random.choice(task_names),
            instance_id = ctx.gen.guid(),

            description = "Task Scheduler successfully started instance of a task"
        }
    end
}
