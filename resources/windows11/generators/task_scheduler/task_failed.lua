-- Task Scheduler Event 103: Task failed
-- Tracks task execution failures

return {
    metadata = {
        name = "task_scheduler.task_failed",
        category = "TASK_SCHEDULER",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Task failed to complete",
        text_template = "[{timestamp}] Event {event_id}: Task Scheduler failed to start task '{task_name}', error: {error_message}",
        tags = {"task_scheduler", "execution", "failure"},
        merge_groups = {"scheduled_tasks"}
    },

    generate = function(ctx, args)
        local task_names = {
            "\\Microsoft\\Windows\\UpdateOrchestrator\\Schedule Scan",
            "\\CustomTasks\\Backup",
            "\\CustomTasks\\Maintenance",
            "\\FailedTask",
            "\\BrokenTask"
        }

        local error_messages = {
            "The operator or administrator has refused the request",
            "The system cannot find the file specified",
            "Access is denied",
            "The task image is corrupt or has been tampered with",
            "The task has been configured with an unsupported combination of account settings and run time options"
        }

        local error_codes = {
            "0x80041315",  -- Task not ready
            "0x80070002",  -- File not found
            "0x80070005",  -- Access denied
            "0x8004131F",  -- An instance of this task is already running
            "0x80041324"   -- The task is not yet valid
        }

        return {
            event_id = 103,
            provider_name = "Microsoft-Windows-TaskScheduler",
            channel = "Microsoft-Windows-TaskScheduler/Operational",
            computer = ctx.gen.windows_computer(),
            level = "Error",
            task_category = "Task failed",
            keywords = "0x8000000000000000",

            task_name = ctx.random.choice(task_names),
            instance_id = ctx.gen.guid(),
            error_code = ctx.random.choice(error_codes),
            error_message = ctx.random.choice(error_messages),

            description = "Task Scheduler failed to start task"
        }
    end
}
