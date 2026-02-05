-- Task Scheduler Event 102: Task completed
-- Tracks successful task completion

return {
    metadata = {
        name = "task_scheduler.task_completed",
        category = "TASK_SCHEDULER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Task completed successfully",
        text_template = "[{timestamp}] Event {event_id}: Task Scheduler successfully completed task '{task_name}', exit code: {exit_code}",
        tags = {"task_scheduler", "execution", "success"},
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
            event_id = 102,
            provider_name = "Microsoft-Windows-TaskScheduler",
            channel = "Microsoft-Windows-TaskScheduler/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "Task completed",
            keywords = "0x8000000000000000",

            task_name = ctx.random.choice(task_names),
            instance_id = ctx.gen.guid(),
            exit_code = 0,
            result_code = "0x0",

            description = "Task Scheduler successfully completed task"
        }
    end
}
