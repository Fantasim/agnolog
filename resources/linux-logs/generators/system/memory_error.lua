-- Memory Error Generator
-- Generates memory error log entries

return {
    metadata = {
        name = "system.memory_error",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Memory error detected",
        text_template = "[{timestamp}] kernel: EDAC MC{mc}: {error_type} error page 0x{page}, offset 0x{offset}, grain {grain}, syndrome 0x{syndrome}, row {row}, channel {channel}, label \"{label}\"",
        tags = {"memory", "ecc", "error"},
        merge_groups = {"system_errors"}
    },

    generate = function(ctx, args)
        local error_types = {"CE", "UE"}

        return {
            mc = ctx.random.int(0, 3),
            error_type = ctx.random.choice(error_types),
            page = ctx.gen.hex_string(8),
            offset = ctx.gen.hex_string(3),
            grain = ctx.random.int(1, 8),
            syndrome = ctx.gen.hex_string(4),
            row = ctx.random.int(0, 65535),
            channel = ctx.random.int(0, 3),
            label = string.format("DIMM_%d", ctx.random.int(0, 7))
        }
    end
}
