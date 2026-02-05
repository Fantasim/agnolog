-- Hardware Disk Bad Block Generator (Event ID 7)
-- Generates bad block on device events

return {
    metadata = {
        name = "hardware.disk_bad_block",
        category = "HARDWARE",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Bad block on device",
        text_template = "Event Type: Error\nEvent Source: Disk\nEvent Category: None\nEvent ID: 7\nComputer: {computer}\nDescription:\nThe device, {device}, has a bad block.",
        tags = {"hardware", "disk", "error", "bad_block"},
        merge_groups = {"disk_errors"}
    },

    generate = function(ctx, args)
        local hardware_data = ctx.data.system and ctx.data.system.hardware
        local devices = (hardware_data and hardware_data.disk_devices) or {
            "\\Device\\Harddisk0\\DR0",
            "\\Device\\Harddisk1\\DR2"
        }

        return {
            computer = ctx.gen.windows_computer(),
            device = ctx.random.choice(devices),
            lba = ctx.random.int(0, 10000000)
        }
    end
}
