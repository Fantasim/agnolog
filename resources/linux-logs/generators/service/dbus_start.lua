-- D-Bus Start Generator
-- Generates D-Bus service activation log entries

return {
    metadata = {
        name = "service.dbus_start",
        category = "SERVICE",
        severity = "INFO",
        recurrence = "RARE",
        description = "D-Bus daemon started",
        text_template = "[{timestamp}] dbus-daemon[{pid}]: Successfully activated service '{service}'",
        tags = {"dbus", "ipc"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local dbus_services = {
            "org.freedesktop.NetworkManager",
            "org.freedesktop.login1",
            "org.freedesktop.systemd1",
            "org.freedesktop.UDisks2",
            "org.freedesktop.Avahi"
        }

        return {
            pid = ctx.random.int(500, 5000),
            service = ctx.random.choice(dbus_services)
        }
    end
}
