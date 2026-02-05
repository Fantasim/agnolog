-- Task Scheduler Event 106: User registered Task Scheduler task
-- Important for security monitoring (persistence mechanism)

return {
    metadata = {
        name = "task_scheduler.task_registered",
        category = "TASK_SCHEDULER",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "User registered Task Scheduler task",
        text_template = "[{timestamp}] Event {event_id}: User {user_context} registered Task Scheduler task '{task_name}'",
        tags = {"task_scheduler", "persistence", "automation"},
        merge_groups = {"scheduled_tasks"}
    },

    generate = function(ctx, args)
        local task_names = {
            "\\Microsoft\\Windows\\UpdateOrchestrator\\Schedule Scan",
            "\\Microsoft\\Windows\\Defender\\Windows Defender Scheduled Scan",
            "\\Microsoft\\Windows\\WindowsUpdate\\Scheduled Start",
            "\\CustomTasks\\Backup",
            "\\CustomTasks\\Maintenance",
            "\\UserTasks\\StartupApp",
            "\\Adobe Acrobat Update Task",
            "\\GoogleUpdateTaskMachine",
            "\\MaintenanceTask",
            "\\DailyCleanup"
        }

        local computer = ctx.gen.windows_computer()
        local username = ctx.gen.windows_username()
        local domain = ctx.gen.windows_domain()

        return {
            event_id = 106,
            provider_name = "Microsoft-Windows-TaskScheduler",
            channel = "Microsoft-Windows-TaskScheduler/Operational",
            computer = computer,
            level = "Information",
            task_category = "Task registered",
            keywords = "0x8000000000000000",

            task_name = ctx.random.choice(task_names),
            user_context = string.format("%s\\%s", domain, username),

            description = "User registered Task Scheduler task"
        }
    end
}
