-- Hardware Error Generator
-- Generates hardware error log entries

return {
    metadata = {
        name = "system.hardware_error",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Hardware error detected",
        text_template = "[{timestamp}] kernel: mce: [Hardware Error]: CPU {cpu_id}: Machine Check Exception: {bank} Bank {bank_num}: {error_code}",
        tags = {"hardware", "mce", "error"},
        merge_groups = {"system_errors"}
    },

    generate = function(ctx, args)
        local banks = {
            "Data Cache", "Instruction Cache", "Bus Unit",
            "Memory Controller", "TLB Unit"
        }

        return {
            cpu_id = ctx.random.int(0, 15),
            bank = ctx.random.choice(banks),
            bank_num = ctx.random.int(0, 7),
            error_code = "0x" .. ctx.gen.hex_string(16)
        }
    end
}
