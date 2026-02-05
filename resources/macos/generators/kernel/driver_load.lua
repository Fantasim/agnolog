return {
    metadata = {
        name = "kernel.driver_load",
        category = "KERNEL",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "Driver loaded",
        text_template = "{timestamp} kernel[0] <{level}>: {subsystem} {category}: Driver {driver_name} loaded successfully",
        tags = {"kernel", "driver", "load"},
        merge_groups = {}
    },
    generate = function(ctx, args)
        local drivers = {"AppleHDA", "AppleIntelGraphics", "AppleNVMe", "AppleUSBXHCI"}
        if ctx.data.kernel.drivers then
            local all_drivers = {}
            for _, cat in pairs(ctx.data.kernel.drivers) do
                for _, drv in ipairs(cat) do
                    table.insert(all_drivers, drv)
                end
            end
            if #all_drivers > 0 then drivers = all_drivers end
        end
        return {
            process = "kernel",
            pid = 0,
            level = "Notice",
            subsystem = "com.apple.kernel",
            category = "driver",
            driver_name = ctx.random.choice(drivers)
        }
    end
}
