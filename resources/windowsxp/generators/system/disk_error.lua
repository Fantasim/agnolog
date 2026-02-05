-- System Disk Error Generator (Event ID 51)
-- Generates disk paging error events

return {
    metadata = {
        name = "system.disk_error",
        category = "SYSTEM",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Disk paging error",
        text_template = "Event Type: Warning\nEvent Source: Disk\nEvent Category: None\nEvent ID: 51\nComputer: {computer}\nDescription:\nAn error was detected on device {device} during a paging operation.\n\nFor more information, see Help and Support Center at http://go.microsoft.com/fwlink/events.asp.",
        tags = {"system", "disk", "hardware", "warning"},
        merge_groups = {"disk_errors"}
    },

    generate = function(ctx, args)
        local hardware_data = ctx.data.system and ctx.data.system.hardware
        local devices = (hardware_data and hardware_data.disk_devices) or {
            "\\Device\\Harddisk0\\DR0",
            "\\Device\\Harddisk0\\DR1"
        }

        return {
            computer = ctx.gen.windows_computer(),
            device = ctx.random.choice(devices),
            error_code = ctx.random.choice({"0xC000009C", "0xC000009D", "0xC0000185"})
        }
    end
}
