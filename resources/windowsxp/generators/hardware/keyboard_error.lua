-- Hardware Keyboard Error Generator (Event ID 4)
-- Generates keyboard controller error

return {
    metadata = {
        name = "hardware.keyboard_error",
        category = "HARDWARE",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Keyboard controller error",
        text_template = "Event Type: Warning\nEvent Source: i8042prt\nEvent Category: None\nEvent ID: 4\nComputer: {computer}\nDescription:\nThe i8042prt driver detected an error on device {device}.",
        tags = {"hardware", "keyboard", "controller", "error"},
        merge_groups = {"hardware_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            device = "\\Device\\KeyboardClass0"
        }
    end
}
