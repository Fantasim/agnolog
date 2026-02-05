-- Hardware ATAPI Error Generator (Event ID 11)
-- Generates ATAPI controller error events

return {
    metadata = {
        name = "hardware.atapi_error",
        category = "HARDWARE",
        severity = "ERROR",
        recurrence = "RARE",
        description = "ATAPI controller error",
        text_template = "Event Type: Error\nEvent Source: atapi\nEvent Category: None\nEvent ID: 11\nComputer: {computer}\nDescription:\nThe driver detected a controller error on {device}.",
        tags = {"hardware", "atapi", "controller", "error"},
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
