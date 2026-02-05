-- System Event 6008: The previous system shutdown was unexpected
-- Critical for detecting system crashes

return {
    metadata = {
        name = "system.unexpected_shutdown",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "RARE",
        description = "The previous system shutdown was unexpected",
        text_template = "[{timestamp}] Event {event_id}: {description} at {shutdown_time}. Reason: {reason}",
        tags = {"system", "shutdown", "crash", "unexpected"},
        merge_groups = {"system_crashes"}
    },

    generate = function(ctx, args)
        local computer_name = ctx.gen.windows_computer()

        -- Shutdown reasons
        local reasons = {
            "Power failure",
            "System hung",
            "Blue screen",
            "Critical process died",
            "Kernel error",
            "Hardware failure"
        }

        -- Generate a timestamp for when the unexpected shutdown occurred (some time in the past)
        local hours_ago = ctx.random.int(1, 72)
        local shutdown_time = string.format("%d hours ago", hours_ago)

        return {
            event_id = 6008,
            provider_name = "EventLog",
            channel = "System",
            computer = computer_name,
            level = "Error",
            task_category = "None",
            keywords = "0x80000000000000",  -- Classic

            shutdown_time = shutdown_time,
            reason = ctx.random.choice(reasons),

            description = "The previous system shutdown was unexpected."
        }
    end
}
