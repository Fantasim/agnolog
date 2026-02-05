-- Segmentation Fault Generator
-- Generates segfault log entries

return {
    metadata = {
        name = "system.segfault",
        category = "SYSTEM",
        severity = "ERROR",
        recurrence = "INFREQUENT",
        description = "Segmentation fault",
        text_template = "[{timestamp}] kernel: {process}[{pid}]: segfault at {address} ip {instruction_ptr} sp {stack_ptr} error {error_code} in {binary}",
        tags = {"segfault", "crash", "kernel"},
        merge_groups = {"system_errors"}
    },

    generate = function(ctx, args)
        local processes = {
            "apache2", "nginx", "mysqld", "postgres", "redis-server",
            "java", "python", "node", "php-fpm", "worker"
        }

        return {
            process = ctx.random.choice(processes),
            pid = ctx.random.int(100, 32768),
            address = "0x" .. ctx.gen.hex_string(16),
            instruction_ptr = "0x" .. ctx.gen.hex_string(16),
            stack_ptr = "0x" .. ctx.gen.hex_string(16),
            error_code = ctx.random.int(4, 7),
            binary = ctx.random.choice(processes) .. "[" .. ctx.gen.hex_string(12) .. "]"
        }
    end
}
