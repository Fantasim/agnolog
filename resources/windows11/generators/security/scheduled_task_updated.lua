-- Security Event 4702: A scheduled task was updated
-- Tracks modifications to scheduled tasks

return {
    metadata = {
        name = "security.scheduled_task_updated",
        category = "SECURITY",
        severity = "INFO",
        recurrence = "INFREQUENT",
        description = "A scheduled task was updated",
        text_template = "[{timestamp}] Event {event_id}: {description} - Task: {task_name}, User: {subject_domain}\\{subject_username}",
        tags = {"security", "scheduled_task", "modification", "audit"},
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
            "\\MaintenanceTask"
        }

        -- Task content (XML snippet)
        local task_content = string.format([[<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Author>%s\\%s</Author>
    <Date>2026-02-05T10:00:00</Date>
  </RegistrationInfo>
  <Triggers>
    <CalendarTrigger>
      <StartBoundary>2026-01-01T02:00:00</StartBoundary>
      <ScheduleByDay>
        <DaysInterval>1</DaysInterval>
      </ScheduleByDay>
    </CalendarTrigger>
  </Triggers>
  <Settings>
    <Enabled>true</Enabled>
  </Settings>
</Task>]], domain, username)

        return {
            event_id = 4702,
            provider_name = "Microsoft-Windows-Security-Auditing",
            channel = "Security",
            computer = computer_name,
            level = "Information",
            task_category = "Scheduled Task",
            keywords = "0x8020000000000000",  -- Audit Success

            -- Subject (who updated the task)
            subject_sid = ctx.gen.sid(),
            subject_username = username,
            subject_domain = domain,
            subject_logon_id = string.format("0x%x", ctx.random.int(100000, 999999999)),

            -- Task information
            task_name = ctx.random.choice(task_names),
            task_content = task_content,

            description = "A scheduled task was updated"
        }
    end
}
