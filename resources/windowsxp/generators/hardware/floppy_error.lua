-- Hardware Floppy Error Generator (Event ID 50)
-- Generates floppy disk controller error

return {
    metadata = {
        name = "hardware.floppy_error",
        category = "HARDWARE",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Floppy disk controller error",
        text_template = "Event Type: Warning\nEvent Source: Floppy\nEvent Category: None\nEvent ID: 50\nComputer: {computer}\nDescription:\nThe driver detected a controller error on {device}.",
        tags = {"hardware", "floppy", "controller", "error"},
        merge_groups = {"hardware_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            device = "\\Device\\Floppy0"
        }
    end
}
