-- Security Event 4699: A scheduled task was deleted
-- Tracks removal of scheduled tasks

return {
    metadata = {
        name = "security.scheduled_task_deleted",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "A scheduled task was deleted",
        text_template = "[{timestamp}] Event {event_id}: {description} - Task: {task_name}, User: {subject_domain}\\{subject_username}",
        tags = {"security", "scheduled_task", "audit"},
        merge_groups = {"security_scheduled_tasks"}
    },

    generate = function(ctx, args)
        local computer_name = ctx.gen.windows_computer()
        local username = ctx.gen.windows_username()
        local domain = ctx.gen.windows_domain()

        -- Common task paths
        local task_names = {
            "\\Microsoft\\Windows\\UpdateOrchestrator\\Schedule Scan",
            "\\Microsoft\\Windows\\Defender\\Windows Defender Scheduled Scan",
            "\\CustomTasks\\Backup",
            "\\CustomTasks\\Maintenance",
            "\\UserTasks\\OldTask",
            "\\TemporaryTask",
            "\\ObsoleteMaintenanceTask"
        }

        return {
            event_id = 4699,
            provider_name = "Microsoft-Windows-Security-Auditing",
            channel = "Security",
            computer = computer_name,
            level = "Information",
            task_category = "Scheduled Task",
            keywords = "0x8020000000000000",  -- Audit Success

            -- Subject (who deleted the task)
            subject_sid = ctx.gen.sid(),
            subject_username = username,
            subject_domain = domain,
            subject_logon_id = string.format("0x%x", ctx.random.int(100000, 999999999)),

            -- Task information
            task_name = ctx.random.choice(task_names),

            description = "A scheduled task was deleted"
        }
    end
}
