-- System Disk Timeout Generator (Event ID 11)
-- Generates disk timeout error events

return {
    metadata = {
        name = "system.disk_timeout",
        category = "SYSTEM",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "Disk timeout",
        text_template = "Event Type: Warning\nEvent Source: Disk\nEvent Category: None\nEvent ID: 11\nComputer: {computer}\nDescription:\nThe driver detected a controller error on {device}.",
        tags = {"system", "disk", "timeout", "hardware", "warning"},
        merge_groups = {"disk_errors"}
    },

    generate = function(ctx, args)
        local hardware_data = ctx.data.system and ctx.data.system.hardware
        local devices = (hardware_data and hardware_data.disk_devices) or {
            "\\Device\\Harddisk0\\DR0",
            "\\Device\\CdRom0"
        }

        return {
            computer = ctx.gen.windows_computer(),
            device = ctx.random.choice(devices)
        }
    end
}
