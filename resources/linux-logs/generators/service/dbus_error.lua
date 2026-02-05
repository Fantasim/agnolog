-- D-Bus Error Generator
-- Generates D-Bus error log entries

return {
    metadata = {
        name = "service.dbus_error",
        category = "SERVICE",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "D-Bus error",
        text_template = "[{timestamp}] dbus-daemon[{pid}]: Failed to activate service '{service}': {reason}",
        tags = {"dbus", "ipc", "error"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local dbus_services = {
            "org.freedesktop.NetworkManager",
            "org.freedesktop.UPower",
            "org.freedesktop.Notifications"
        }

        local reasons = {
            "timed out",
            "not found",
            "permission denied",
            "already running"
        }

        return {
            pid = ctx.random.int(500, 5000),
            service = ctx.random.choice(dbus_services),
            reason = ctx.random.choice(reasons)
        }
    end
}
