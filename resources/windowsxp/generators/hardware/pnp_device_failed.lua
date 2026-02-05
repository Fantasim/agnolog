-- Hardware PnP Device Failed Generator (Event ID 219)
-- Generates Plug and Play device install failure

return {
    metadata = {
        name = "hardware.pnp_device_failed",
        category = "HARDWARE",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "PnP device install failed",
        text_template = "Event Type: Warning\nEvent Source: PlugPlayManager\nEvent Category: None\nEvent ID: 219\nComputer: {computer}\nDescription:\nThe driver {driver} for device {device_name} could not be installed because it could not find any related device information in the driver's INF file.",
        tags = {"hardware", "pnp", "install", "failed"},
        merge_groups = {"hardware_errors"}
    },

    generate = function(ctx, args)
        local drivers = {
            "usbstor.inf",
            "usbhub.inf",
            "cdrom.inf",
            "printer.inf",
            "netrtl8139.inf"
        }

        local devices = {
            "USB Mass Storage Device",
            "USB Composite Device",
            "Generic USB Hub",
            "CD-ROM Drive",
            "USB Printing Support"
        }

        return {
            computer = ctx.gen.windows_computer(),
            driver = ctx.random.choice(drivers),
            device_name = ctx.random.choice(devices)
        }
    end
}
