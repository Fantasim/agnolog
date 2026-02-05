-- System Error Generator (Event ID 1001)
-- Generates system error events

return {
    metadata = {
        name = "system.system_error",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "RARE",
        description = "System error",
        text_template = "Event Type: Error\nEvent Source: System\nEvent Category: None\nEvent ID: 1001\nComputer: {computer}\nDescription:\nThe computer has rebooted from a bugcheck. The bugcheck was: {bugcheck_code} ({param1}, {param2}, {param3}, {param4}). A dump was saved in: {dump_file}.",
        tags = {"system", "error", "bugcheck", "critical"},
        merge_groups = {"system_errors"}
    },

    generate = function(ctx, args)
        local bugcheck_codes = {
            "0x0000000a", -- IRQL_NOT_LESS_OR_EQUAL
            "0x0000001e", -- KMODE_EXCEPTION_NOT_HANDLED
            "0x00000050", -- PAGE_FAULT_IN_NONPAGED_AREA
            "0x0000007f", -- UNEXPECTED_KERNEL_MODE_TRAP
            "0x000000d1"  -- DRIVER_IRQL_NOT_LESS_OR_EQUAL
        }

        return {
            computer = ctx.gen.windows_computer(),
            bugcheck_code = ctx.random.choice(bugcheck_codes),
            param1 = string.format("0x%08x", ctx.random.int(0, 0xffffffff)),
            param2 = string.format("0x%08x", ctx.random.int(0, 0xffffffff)),
            param3 = string.format("0x%08x", ctx.random.int(0, 0xffffffff)),
            param4 = string.format("0x%08x", ctx.random.int(0, 0xffffffff)),
            dump_file = "C:\\WINDOWS\\MEMORY.DMP"
        }
    end
}
