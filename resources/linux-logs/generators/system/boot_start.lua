-- System Boot Start Generator
-- Generates system boot initiation log entries

return {
    metadata = {
        name = "system.boot_start",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "RARE",
        description = "System boot initiated",
        text_template = "[{timestamp}] kernel: [{boot_offset}] Linux version {kernel_version} ({hostname}) (gcc version {gcc_version}) #1 SMP {build_date}",
        tags = {"boot", "kernel", "system"},
        merge_groups = {"system_lifecycle"}
    },

    generate = function(ctx, args)
        local major = ctx.random.int(4, 6)
        local minor = ctx.random.int(0, 20)
        local patch = ctx.random.int(0, 100)
        local build = ctx.random.int(1, 300)

        local gcc_major = ctx.random.int(9, 13)
        local gcc_minor = ctx.random.int(0, 5)

        -- Build hostname from YAML data
        local prefixes = ctx.data.network.hostnames.prefixes or {"server"}
        local suffixes = ctx.data.network.hostnames.suffixes or {"01"}
        local hostname = ctx.random.choice(prefixes) .. "-" .. ctx.random.choice(suffixes)

        return {
            boot_offset = string.format("%d.%06d", ctx.random.int(0, 5), ctx.random.int(0, 999999)),
            kernel_version = string.format("%d.%d.%d-%d-generic", major, minor, patch, build),
            hostname = hostname,
            gcc_version = string.format("%d.%d.0", gcc_major, gcc_minor),
            build_date = string.format("SMP %s", os.date("%a %b %d %H:%M:%S UTC %Y"))
        }
    end
}
