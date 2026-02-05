-- Hardware USB Power Exceeded Generator (Event ID 20)
-- Generates USB hub power budget exceeded

return {
    metadata = {
        name = "hardware.usb_power_exceeded",
        category = "HARDWARE",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "USB hub power budget exceeded",
        text_template = "Event Type: Warning\nEvent Source: usbhub\nEvent Category: None\nEvent ID: 20\nComputer: {computer}\nDescription:\nA USB device on hub {hub} has exceeded its hub port's power budget.",
        tags = {"hardware", "usb", "power", "hub"},
        merge_groups = {"hardware_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            hub = "Hub_" .. ctx.random.int(0, 3),
            port = ctx.random.int(1, 8)
        }
    end
}
