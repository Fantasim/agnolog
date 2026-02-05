-- Task Scheduler Event 107: Task triggered
-- Tracks task trigger activation

return {
    metadata = {
        name = "task_scheduler.task_triggered",
        category = "TASK_SCHEDULER",
        severity = "INFO",
        recurrence = "FREQUENT",
        description = "Task triggered on scheduler",
        text_template = "[{timestamp}] Event {event_id}: Task Scheduler launched task '{task_name}' due to {trigger_type}",
        tags = {"task_scheduler", "trigger"},
        merge_groups = {"scheduled_tasks"}
    },

    generate = function(ctx, args)
        local task_names = {
            "\\Microsoft\\Windows\\UpdateOrchestrator\\Schedule Scan",
            "\\Microsoft\\Windows\\Defender\\Windows Defender Scheduled Scan",
            "\\Microsoft\\Windows\\WindowsUpdate\\Scheduled Start",
            "\\CustomTasks\\Backup",
            "\\CustomTasks\\Maintenance"
        }

        local trigger_types = {
            "a time trigger condition",
            "an event trigger condition",
            "a registration trigger condition",
            "a logon trigger condition",
            "a boot trigger condition"
        }

        return {
            event_id = 107,
            provider_name = "Microsoft-Windows-TaskScheduler",
            channel = "Microsoft-Windows-TaskScheduler/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Information",
            task_category = "Task triggered",
            keywords = "0x8000000000000000",

            task_name = ctx.random.choice(task_names),
            trigger_type = ctx.random.choice(trigger_types),

            description = "Task Scheduler launched task due to trigger"
        }
    end
}
