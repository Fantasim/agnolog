-- Firmware Bug Generator
-- Generates firmware bug detection log entries

return {
    metadata = {
        name = "system.firmware_bug",
        category = "SYSTEM",
        severity = "WARNING",
        recurrence = "RARE",
        description = "Firmware bug detected",
        text_template = "[{timestamp}] kernel: [Firmware Bug]: {description}",
        tags = {"firmware", "bug", "bios"},
        merge_groups = {}
    },

    generate = function(ctx, args)
        local bugs = {
            "ACPI region does not cover the entire command/response buffer",
            "TPM chip has been reset after initialization",
            "the BIOS has corrupted hw-PMU resources",
            "CPU vendor/id mismatch",
            "TSC_DEADLINE disabled due to Errata",
            "NUMA distance information missing for nodes"
        }

        return {
            description = ctx.random.choice(bugs)
        }
    end
}
