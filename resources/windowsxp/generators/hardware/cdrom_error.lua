-- Hardware CD-ROM Error Generator (Event ID 15)
-- Generates CD-ROM block error events

return {
    metadata = {
        name = "hardware.cdrom_error",
        category = "HARDWARE",
        severity = "WARNING",
        recurrence = "INFREQUENT",
        description = "CD-ROM block error",
        text_template = "Event Type: Warning\nEvent Source: Cdrom\nEvent Category: None\nEvent ID: 15\nComputer: {computer}\nDescription:\nThe device, {device}, has a bad block.",
        tags = {"hardware", "cdrom", "error", "bad_block"},
        merge_groups = {"disk_errors"}
    },

    generate = function(ctx, args)
        return {
            computer = ctx.gen.windows_computer(),
            device = "\\Device\\CdRom0"
        }
    end
}
