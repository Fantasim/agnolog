-- System Disk Controller Error Generator (Event ID 9)
-- Generates disk controller error events

return {
    metadata = {
        name = "system.disk_controller_error",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Disk controller error",
        text_template = "Event Type: Error\nEvent Source: atapi\nEvent Category: None\nEvent ID: 9\nComputer: {computer}\nDescription:\nThe device, {device}, did not respond within the timeout period.",
        tags = {"system", "disk", "controller", "hardware", "error"},
        merge_groups = {"disk_errors"}
    },

    generate = function(ctx, args)
        local hardware_data = ctx.data.system and ctx.data.system.hardware
        local controllers = (hardware_data and hardware_data.disk_controllers) or {
            "\\Device\\Ide\\IdePort0",
            "\\Device\\Ide\\IdePort1"
        }

        return {
            computer = ctx.gen.windows_computer(),
            device = ctx.random.choice(controllers)
        }
    end
}
