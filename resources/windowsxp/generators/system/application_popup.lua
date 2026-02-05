-- System Application Popup Generator (Event ID 26)
-- Generates application popup notification

return {
    metadata = {
        name = "system.application_popup",
        category = "SYSTEM",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Application popup notification",
        text_template = "Event Type: Warning\nEvent Source: Application Popup\nEvent Category: None\nEvent ID: 26\nComputer: {computer}\nDescription:\nApplication popup: {title} : {message}",
        tags = {"system", "application", "popup", "warning"},
        merge_groups = {"application_notifications"}
    },

    generate = function(ctx, args)
        local popups = {
            {title = "System Error", message = "An error occurred during a paging operation."},
            {title = "Delayed Write Failed", message = "Windows was unable to save all the data for the file. The data has been lost."},
            {title = "Low Disk Space", message = "You are running out of disk space on Local Disk (C:)."},
            {title = "Virtual Memory Minimum Too Low", message = "Your system is low on virtual memory."}
        }

        local popup = ctx.random.choice(popups)

        return {
            computer = ctx.gen.windows_computer(),
            title = popup.title,
            message = popup.message
        }
    end
}
