-- Kernel Panic Generator
-- Generates kernel panic log entries

return {
    metadata = {
        name = "system.kernel_panic",
        category = "SYSTEM",
        severity = "CRITICAL",
        recurrence = "RARE",
        description = "Kernel panic occurred",
        text_template = "[{timestamp}] kernel: Kernel panic - {reason}: {details}",
        tags = {"kernel", "critical", "crash"},
        merge_groups = {"system_errors"}
    },

    generate = function(ctx, args)
        local panic_reasons = {
            "not syncing",
            "VFS: Unable to mount root fs",
            "Fatal exception",
            "Attempted to kill init",
            "Out of memory and no killable processes",
            "No working init found"
        }

        local error_codes = ctx.data.constants.error_codes.errno or {}
        local errno_list = {}
        for code, _ in pairs(error_codes) do
            table.insert(errno_list, code)
        end

        if #errno_list == 0 then
            errno_list = {"ENOMEM", "EIO", "EINVAL"}
        end

        return {
            reason = ctx.random.choice(panic_reasons),
            details = ctx.random.choice(errno_list),
            cpu_id = ctx.random.int(0, 15),
            instruction_ptr = "0x" .. ctx.gen.hex_string(16)
        }
    end
}
