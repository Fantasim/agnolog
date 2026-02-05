-- Hardware Network Adapter Error Generator (Event ID 5002)
-- Generates network adapter error

return {
    metadata = {
        name = "hardware.network_adapter_error",
        category = "HARDWARE",
        severity = "ERROR",
        recurrence = "RARE",
        description = "Network adapter error",
        text_template = "Event Type: Error\nEvent Source: {adapter_driver}\nEvent Category: None\nEvent ID: 5002\nComputer: {computer}\nDescription:\n{adapter_name} has detected that the network cable is unplugged.",
        tags = {"hardware", "network", "adapter", "error"},
        merge_groups = {"hardware_errors"}
    },

    generate = function(ctx, args)
        local hardware_data = ctx.data.system and ctx.data.system.hardware
        local adapters = (hardware_data and hardware_data.network_adapters) or {
            "Realtek RTL8139 Family PCI Fast Ethernet NIC",
            "Intel(R) PRO/1000 MT Network Connection"
        }

        local adapter = ctx.random.choice(adapters)
        local driver = ctx.random.choice({"RTL8139", "E1000", "NE2000"})

        return {
            computer = ctx.gen.windows_computer(),
            adapter_name = adapter,
            adapter_driver = driver
        }
    end
}
