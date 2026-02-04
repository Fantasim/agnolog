-- Technical Packet Send Generator

return {
    metadata = {
        name = "technical.packet_send",
        category = "TECHNICAL",
        severity = "DEBUG",
        recurrence = "VERY_FREQUENT",
        description = "Packet sent",
        text_template = "[{timestamp}] PKT_SEND: {packet_type} to {client} ({size}b)",
        tags = {"technical", "network", "packet"}
    },

    generate = function(ctx, args)
        local packet_types = {
            "AUTH", "MOVE", "CHAT", "COMBAT", "INVENTORY", "TRADE",
            "QUEST", "GUILD", "PARTY", "SPELL", "ITEM", "NPC"
        }

        local packet_size_min = 32
        local packet_size_max = 4096

        if ctx.data.constants and ctx.data.constants.network then
            local nc = ctx.data.constants.network
            packet_types = nc.packet_types or packet_types
            packet_size_min = nc.packet_size_min or 32
            packet_size_max = nc.packet_size_max or 4096
        end

        return {
            packet_type = ctx.random.choice(packet_types),
            packet_id = ctx.random.int(1, 1000000000),
            client = ctx.gen.ip_address() .. ":" .. ctx.random.int(1024, 65535),
            size = ctx.random.int(packet_size_min, packet_size_max),
            sequence = ctx.random.int(1, 1000000),
            compressed = ctx.random.float() < 0.3
        }
    end
}
