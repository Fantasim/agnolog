-- System Notification Posted Generator
-- Generates system notification log entries

return {
    metadata = {
        name = "system.notification_posted",
        category = "SYSTEM",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "System notification posted",
        text_template = "{timestamp} {process}[{pid}] <{level}>: {subsystem} {category}: Posted notification {notification_name}",
        tags = {"system", "notification", "ipc"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local notifications = {
            "NSApplicationDidBecomeActiveNotification",
            "NSApplicationDidResignActiveNotification",
            "NSSystemTimeZoneDidChangeNotification",
            "NSWorkspaceDidWakeNotification",
            "NSWorkspaceWillSleepNotification",
            "NSWorkspaceSessionDidBecomeActiveNotification",
            "NSWorkspaceSessionDidResignActiveNotification",
            "com.apple.system.config.network_change",
            "com.apple.system.timezone"
        }

        return {
            process = "notifyd",
            pid = ctx.random.int(50, 500),
            level = "Debug",
            subsystem = "com.apple.notifyd",
            category = "notification",
            notification_name = ctx.random.choice(notifications),
            sender_pid = ctx.random.int(100, 65535),
            receiver_count = ctx.random.int(1, 20)
        }
    end
}
