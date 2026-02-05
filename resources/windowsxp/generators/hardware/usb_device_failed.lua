-- Hardware USB Device Failed Generator
-- Generates USB device enumeration failure events

return {
    metadata = {
        name = "hardware.usb_device_failed",
        category = "HARDWARE",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "USB device enumeration failed",
        text_template = "Event Type: Warning\nEvent Source: usbhub\nEvent Category: None\nEvent ID: 20\nComputer: {computer}\nDescription:\nA USB device has exceeded its hub power budget.",
        tags = {"hardware", "usb", "power", "warning"},
        merge_groups = {"hardware_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            port = ctx.random.int(1, 8)
        }
    end
}
