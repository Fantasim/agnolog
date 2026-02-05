-- System DHCP Lease Generator
-- Generates DHCP IP address lease events

return {
    metadata = {
        name = "system.dhcp_lease",
        category = "SYSTEM",
        severity = "INFO",
        recurrence = "NORMAL",
        description = "DHCP lease obtained",
        text_template = "Event Type: Information\nEvent Source: Dhcp\nEvent Category: None\nEvent ID: 1001\nComputer: {computer}\nDescription:\nYour computer has obtained an IP address from the DHCP server {dhcp_server} for the Network Card with network address {mac_address}. The IP address is {ip_address}.",
        tags = {"system", "dhcp", "network", "lease"},
        merge_groups = {"network_config"}
    },

    generate = function(ctx, args)
        local hardware_data = ctx.data.system and ctx.data.system.hardware
        local mac_prefixes = (hardware_data and hardware_data.mac_address_prefixes) or {"00:0C:29", "00:50:56"}

        local mac_prefix = ctx.random.choice(mac_prefixes)
        local mac_suffix = string.format("%02X:%02X:%02X",
            ctx.random.int(0, 255),
            ctx.random.int(0, 255),
            ctx.random.int(0, 255))

        return {
            computer = ctx.gen.windows_computer(),
            dhcp_server = ctx.gen.ip_address(true),
            mac_address = mac_prefix .. ":" .. mac_suffix,
            ip_address = ctx.gen.ip_address(true)
        }
    end
}
