-- Hardware Serial Overrun Generator (Event ID 4)
-- Generates serial driver overrun events

return {
    metadata = {
        name = "hardware.serial_overrun",
        category = "HARDWARE",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Serial driver detected overrun",
        text_template = "Event Type: Warning\nEvent Source: Serial\nEvent Category: None\nEvent ID: 4\nComputer: {computer}\nDescription:\nThe {port} serial driver detected a hardware overrun on device {device}.",
        tags = {"hardware", "serial", "overrun", "warning"},
        merge_groups = {"hardware_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            port = "COM" .. ctx.random.int(1, 4),
            device = "\\Device\\Serial" .. ctx.random.int(0, 3)
        }
    end
}
